import '../../ui/features/auth/data/models/login_response_model.dart';

class UsersResponseModel {
  final String? message;
  final List<User>? users;

  UsersResponseModel({
    this.message,
    this.users,
  });

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    return UsersResponseModel(
      message: json['message'] as String?,
      users: (json['data'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': users?.map((e) => e.toJson()).toList(),
    };
  }
}
