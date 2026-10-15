import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/login_request_model.dart';
import '../data/repos/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> emitLoginStates({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final result = await _loginRepo.login(
      LoginRequestModel(email: email.trim(), password: password),
    );
    result.fold(
      (failure) => emit(LoginError(error: failure.toString())),
      (response) => emit(LoginSuccess(response)),
    );
  }
}
