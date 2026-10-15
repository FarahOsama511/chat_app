import 'dart:async';
import 'dart:developer';
import 'package:chatapp/core/networking/api_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'api_constants.dart';
export 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

/// Pusher Channels configuration and implementation matching the official pub.dev documentation:
class PusherConfig {
  static const String appId = "2189672";
  static const String apiKey = "894b4ca4a2efc1ed42f9";
  static const String cluster = "eu";

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  Completer<void>? _connectedCompleter;
  String? _socketId;
  String _currentState = 'DISCONNECTED';

  String? get socketId => _socketId;
  bool get isConnected => _currentState == 'CONNECTED';

  /// Initialization
  Future<void> init({
    String apiKey = apiKey,
    String cluster = cluster,
    void Function(dynamic currentState, dynamic previousState)?
    onConnectionStateChange,
    void Function(String message, int? code, dynamic e)? onError,
    void Function(String channelName, dynamic data)? onSubscriptionSucceeded,
    void Function(String message, dynamic e)? onSubscriptionError,
    void Function(String event, String reason)? onDecryptionFailure,
    void Function(String channelName, PusherMember member)? onMemberAdded,
    void Function(String channelName, PusherMember member)? onMemberRemoved,
    dynamic Function(String channelName, String socketId, dynamic options)?
    onAuthorizer,
    void Function(PusherEvent event)? onEvent,
  }) async {
    try {
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) async {
          log('Pusher state: $previousState -> $currentState');
          _currentState = currentState.toString();

          if (currentState == 'CONNECTED') {
            try {
              _socketId = await _pusher.getSocketId();
              log('Pusher connected with socketId: $_socketId');
            } catch (e) {
              log('Pusher error getting socketId on connect: $e');
            }

            if (_connectedCompleter != null &&
                !_connectedCompleter!.isCompleted) {
              _connectedCompleter!.complete();
            }
          }

          onConnectionStateChange?.call(currentState, previousState);
        },
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer:
            onAuthorizer ??
            (String channelName, String socketId, dynamic options) async {
              _socketId = socketId;
              log(
                "Pusher onAuthorizer: authorizing $channelName with socketId $socketId",
              );
              try {
                final DioHelper dioHelper = DioHelper();
                final response = await dioHelper.postData(
                  url: ApiEndpoints.broadcastingAuth,
                  data: {'socket_id': socketId, 'channel_name': channelName},
                );
                log("Pusher onAuthorizer SUCCESS: ${response.data}");
                return response.data;
              } catch (e) {
                log("Pusher onAuthorizer ERROR: $e");
                rethrow;
              }
            },
        onEvent: onEvent,
      );
    } catch (e) {
      log("Pusher init ERROR: $e");
      rethrow;
    }
  }

  Future<void> connect() async {
    try {
      _connectedCompleter = Completer<void>();

      await _pusher.connect();

      await _connectedCompleter!.future;

      _socketId ??= await _pusher.getSocketId();
    } catch (e) {
      log("Pusher connect ERROR: $e");
      rethrow;
    }
  }

  /// Disconnecting
  Future<void> disconnect() async {
    try {
      await _pusher.disconnect();
      _currentState = 'DISCONNECTED';
      _socketId = null;
    } catch (e) {
      log("Pusher disconnect ERROR: $e");
      rethrow;
    }
  }

  /// Subscribing
  Future<PusherChannel> subscribe({
    required String channelName,
    void Function(dynamic event)? onEvent,
    void Function(String channelName, dynamic data)? onSubscriptionSucceeded,
    void Function(String message, dynamic error)? onSubscriptionError,
    void Function(String channelName, PusherMember member)? onMemberAdded,
    void Function(String channelName, PusherMember member)? onMemberRemoved,
  }) async {
    try {
      return await _pusher.subscribe(
        channelName: channelName,
        onEvent: onEvent,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );
    } catch (e) {
      log("Pusher subscribe ERROR on $channelName: $e");
      rethrow;
    }
  }

  /// Unsubscribing
  Future<void> unsubscribe({required String channelName}) async {
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (e) {
      log("Pusher unsubscribe ERROR on $channelName: $e");
      rethrow;
    }
  }

  Future<String?> getSocketId() async {
    _socketId ??= await _pusher.getSocketId();
    return _socketId;
  }
}
