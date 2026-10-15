import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/networking/api_constants.dart';
import '../../core/networking/api_service.dart';
import '../models/room_messages_response_model.dart';

abstract class MessagesRepo {
  Future<Either<String, List<MessageItemModel>>> getRoomMessages(int roomId);
  Future<Either<String, MessageItemModel>> sendMessage(
    int roomId,
    SendMessageRequestModel request,
    String socketId,
  );
}

class MessagesRepoImpl implements MessagesRepo {
  final DioHelper _dioHelper;

  MessagesRepoImpl(this._dioHelper);

  @override
  Future<Either<String, List<MessageItemModel>>> getRoomMessages(
    int roomId,
  ) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.getRoomMessages(roomId),
      );

      final responseModel = RoomMessagesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (responseModel.status == false) {
        return Left(responseModel.message ?? 'Failed to retrieve messages');
      }

      return Right(responseModel.data ?? []);
    } catch (e) {
      log('Get Room Messages Error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MessageItemModel>> sendMessage(
    int roomId,
    SendMessageRequestModel request,
    String socketId,
  ) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.sendMessage(roomId),
        data: await request.toFormData(),
        headers: {
          'X-Socket-ID': socketId,
        },
      
      );
      final responseModel = SendMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (responseModel.status == false) {
        return Left(responseModel.message ?? 'Failed to send message');
      }

      if (responseModel.data != null) {
        return Right(responseModel.data!);
      }

      return Right(
        MessageItemModel(
          message: request.body,
          type: request.type,
          isMe: true,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    } catch (e) {
      log('Send Message Error: $e');
      return Left(e.toString());
    }
  }
}
