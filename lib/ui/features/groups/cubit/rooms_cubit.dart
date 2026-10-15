import 'package:chatapp/data/repositories/group_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/group_model.dart';
import 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final GroupRepo _roomsRepo;
  RoomsCubit(this._roomsRepo) : super(RoomsInitial());
  List<GroupModel> chats = [];
  String? currentType;

  Future<void> emitGetRooms({String? type, bool showLoading = true}) async {
    currentType = type;
    if (showLoading) {
      emit(RoomsLoading());
    }
    final result = await _roomsRepo.getRooms(type: type);
    result.fold(
      (failure) {
        if (showLoading || state is! RoomsSuccess) {
          emit(RoomsError(failure));
        }
      },
      (rooms) {
        chats = rooms;
        emit(RoomsSuccess(rooms));
      },
    );
  }
}
