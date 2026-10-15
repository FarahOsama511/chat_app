import 'package:dio/dio.dart';

/// Response model returned by the server when creating a group / room
class CreateGroupResponseModel {
  final bool? status;
  final String? message;
  final GroupModel? data;
  final List<dynamic>? errors;

  const CreateGroupResponseModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory CreateGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateGroupResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? GroupModel.fromJson(json['data'] as Map<String, dynamic>)
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

class GroupModel {
  final int? id;
  final String? orderId;
  final String? name;
  final String? description;
  final String? type;
  final String? image;
  final int? unreadMessagesCount;
  final dynamic lastMessage;

  const GroupModel({
    this.id,
    this.orderId,
    this.name,
    this.description,
    this.type,
    this.image,
    this.unreadMessagesCount,
    this.lastMessage,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int?,
      orderId: json['order_id']?.toString(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      unreadMessagesCount: json['unread_messages_count'] is num
          ? (json['unread_messages_count'] as num).toInt()
          : int.tryParse(json['unread_messages_count']?.toString() ?? '') ?? 0,
      lastMessage: json['last_message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'name': name,
      'description': description,
      'type': type,
      'image': image,
      'unread_messages_count': unreadMessagesCount,
      'last_message': lastMessage,
    };
  }

  /// Get the display text for the last message / description
  String get displayMessage {
    if (lastMessage != null) {
      if (lastMessage is Map) {
        final msg = lastMessage['body'] ?? lastMessage['message'];
        if (msg != null && msg.toString().trim().isNotEmpty) {
          return msg.toString().trim();
        }
      } else if (lastMessage is String &&
          lastMessage.toString().trim().isNotEmpty) {
        return lastMessage.toString().trim();
      }
    }
    if (description != null && description!.trim().isNotEmpty) {
      return description!.trim();
    }
    return type == 'group' ? 'Group created' : 'No messages yet';
  }
}

/// Request model used to create a new group / room via multipart form-data
class CreateGroupRequestModel {
  final String name;
  final String? description;
  final String? imagePath;
  final List<int> members;

  const CreateGroupRequestModel({
    required this.name,
    this.description,
    this.imagePath,
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (imagePath != null) 'image': imagePath,
      'members': members,
    };
  }

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
    };

    final formData = FormData.fromMap(map);

    // Add members as array items: members[]
    for (final memberId in members) {
      formData.fields.add(MapEntry('members[]', memberId.toString()));
    }

    // Add image file if provided
    if (imagePath != null && imagePath!.trim().isNotEmpty) {
      final fileName = imagePath!.split(RegExp(r'[/\\]')).last;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(imagePath!, filename: fileName),
        ),
      );
    }
    return formData;
  }
}
