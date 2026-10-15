import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/messages_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final MessagesRepo _messagesRepo;

  ChatCubit(this._messagesRepo) : super(ChatInitial());

  Future<void> emitGetRoomMessages(int roomId) async {
    emit(ChatLoading());
    final result = await _messagesRepo.getRoomMessages(roomId);
    result.fold(
      (failure) => emit(ChatError(failure)),
      (messages) => emit(ChatSuccess(messages)),
    );
  }
}
