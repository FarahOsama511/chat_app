import 'group_model.dart';

class RoomsResponseModel {
  final bool? status;
  final String? message;
  final List<GroupModel>? rooms;
  final List<dynamic>? errors;

  const RoomsResponseModel({
    this.status,
    this.message,
    this.rooms,
    this.errors,
  });

  factory RoomsResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomsResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      rooms: (json['data'] as List<dynamic>?)
          ?.map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': rooms?.map((e) => e.toJson()).toList(),
      'errors': errors,
    };
  }
}
