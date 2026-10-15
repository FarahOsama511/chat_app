import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/group_model.dart';
import '../../../../data/repositories/group_repo.dart';
import 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final GroupRepo _groupRepo;
  CreateGroupCubit(this._groupRepo) : super(CreateGroupInitial());

  Future<void> emitCreateGroup({
    required CreateGroupRequestModel request,
  }) async {
    await createGroupWithModel(request);
  }

  Future<void> createGroupWithModel(CreateGroupRequestModel request) async {
    emit(CreateGroupLoading());
    final result = await _groupRepo.createGroup(request);
    result.fold(
      (failure) => emit(CreateGroupError(error: failure)),
      (response) => emit(CreateGroupSuccess(response)),
    );
  }
}
