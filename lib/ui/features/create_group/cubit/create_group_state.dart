import '../../../../data/models/group_model.dart';

abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoading extends CreateGroupState {}

class CreateGroupSuccess extends CreateGroupState {
  final CreateGroupResponseModel response;

  CreateGroupSuccess(this.response);
}

class CreateGroupError extends CreateGroupState {
  final String error;

  CreateGroupError({required this.error});
}
