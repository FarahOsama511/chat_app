import '../../auth/data/models/login_response_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<User> users;

  UsersSuccess(this.users);
}

class UsersError extends UsersState {
  final String error;

  UsersError(this.error);
}
