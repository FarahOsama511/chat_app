import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/users_repo.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepo _usersRepo;

  UsersCubit(this._usersRepo) : super(UsersInitial());

  Future<void> emitGetUsers() async {
    emit(UsersLoading());
    final result = await _usersRepo.getUsers();
    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersSuccess(users)),
    );
  }
}
