import 'dart:io';
import 'package:dio/dio.dart';

class RoomMessagesResponseModel {
  final bool? status;
  final String? message;
  final List<MessageItemModel>? data;

  const RoomMessagesResponseModel({this.status, this.message, this.data});

  factory RoomMessagesResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomMessagesResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MessageItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class MessageItemModel {
  final int? id;
  final String? message;
  final String? type;
  final String? createdAt;
  final bool isMe;
  final MessageSenderModel? sender;

  const MessageItemModel({
    this.id,
    this.message,
    this.type,
    this.createdAt,
    this.isMe = false,
    this.sender,
  });

  factory MessageItemModel.fromJson(Map<String, dynamic> json) {
    MessageSenderModel? sender;
    if (json['sender'] != null && json['sender'] is Map) {
      final senderMap = json['sender'] is Map<String, dynamic>
          ? json['sender'] as Map<String, dynamic>
          : (json['sender'] as Map).map((k, v) => MapEntry(k.toString(), v));
      sender = MessageSenderModel.fromJson(senderMap);
    } else if (json['sender_id'] != null) {
      sender = MessageSenderModel(
        id: json['sender_id'] is num
            ? (json['sender_id'] as num).toInt()
            : int.tryParse(json['sender_id']?.toString() ?? ''),
        name: json['sender_name']?.toString(),
        image: json['sender_image']?.toString(),
      );
    }

    return MessageItemModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? ''),
      message: (json['message'] ?? json['body'] ?? json['text'])?.toString(),
      type: json['type'] as String? ?? 'text',
      createdAt: json['created_at'] as String?,
      isMe: json['is_me'] as bool? ?? false,
      sender: sender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type,
      'created_at': createdAt,
      'is_me': isMe,
      'sender': sender?.toJson(),
    };
  }
}

class MessageSenderModel {
  final int? id;
  final String? name;
  final String? image;

  const MessageSenderModel({this.id, this.name, this.image});

  factory MessageSenderModel.fromJson(Map<String, dynamic> json) {
    return MessageSenderModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}

class SendMessageType {
  static const String text = 'text';
  static const String audio = 'audio';
  static const String video = 'video';
  static const String file = 'file';
  static const String image = 'image';

  static const List<String> allTypes = [text, audio, video, file, image];
}

class SendMessageRequestModel {
  final String? body;
  final String? type;
  final File? file;

  const SendMessageRequestModel({this.body, this.type, this.file});

  bool get isUrl {
    if (body == null) return false;
    final lower = body!.trim().toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    // 1. Add type field if available
    if (type != null && type!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('type', type!.trim().toLowerCase()));
    }

    // 2. Add body: file upload vs text / URL
    if (file != null) {
      final fileName = file!.path.split(RegExp(r'[/\\]')).last;
      formData.files.add(
        MapEntry(
          'body',
          await MultipartFile.fromFile(file!.path, filename: fileName),
        ),
      );
    } else if (body != null && body!.trim().isNotEmpty) {
      final trimmedBody = body!.trim();

      // If not text and not a URL, check if body is a local file path
      if (type?.toLowerCase() != SendMessageType.text && !isUrl) {
        try {
          final localFile = File(trimmedBody);
          if (localFile.existsSync()) {
            final fileName = localFile.path.split(RegExp(r'[/\\]')).last;
            formData.files.add(
              MapEntry(
                'body',
                await MultipartFile.fromFile(
                  localFile.path,
                  filename: fileName,
                ),
              ),
            );
            return formData;
          }
        } catch (_) {
          // In case file system operations fail, fall through to text field
        }
      }

      // Default: add as text field (plain text or URL link)
      formData.fields.add(MapEntry('body', trimmedBody));
    }

    return formData;
  }

  Map<String, dynamic> toJson() => {
    if (body != null) 'body': body,
    if (type != null) 'type': type,
  };
}

class SendMessageResponseModel {
  final bool? status;
  final String? message;
  final MessageItemModel? data;
  final List<dynamic>? errors;

  const SendMessageResponseModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MessageItemModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}
