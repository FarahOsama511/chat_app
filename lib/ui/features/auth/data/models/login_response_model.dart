class LoginResponseModel {
  final bool? status;
  final String? message;
  final String? token;
  final User? user;

  const LoginResponseModel({this.status, this.message, this.token, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      token: json['data']['token'] as String?,
      user: json['data']['user'] != null
          ? User.fromJson(json['data']['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {'token': token, 'user': user?.toJson()},
    };
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? image;

  User({this.id, this.name, this.email, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'image': image};
  }
}
