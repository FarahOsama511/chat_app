import '../../data/models/login_response_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel response;

  LoginSuccess(this.response);
}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}
