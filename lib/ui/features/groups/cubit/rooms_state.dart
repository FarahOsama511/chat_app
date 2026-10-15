import '../../../../data/models/group_model.dart';

abstract class RoomsState {}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsSuccess extends RoomsState {
  final List<GroupModel> rooms;

  RoomsSuccess(this.rooms);
}

class RoomsError extends RoomsState {
  final String error;

  RoomsError(this.error);
}
