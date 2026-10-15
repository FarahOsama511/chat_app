import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/room_messages_response_model.dart';
import '../../../../data/repositories/messages_repo.dart';
import 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final MessagesRepo _messagesRepo;

  SendMessageCubit(this._messagesRepo) : super(SendMessageInitial());

  Future<void> emitSendMessage(
    int roomId, 
    String socketId,
    {
    String? body,
    String? type,
    File? file,
  }) async {
    emit(SendMessageLoading());
    final result = await _messagesRepo.sendMessage(
      roomId,
      SendMessageRequestModel(
        body: body,
        type: type,
        file: file,
      ),
      socketId
    );
    result.fold(
      (failure) => emit(SendMessageError(failure)),
      (message) => emit(SendMessageSuccess(message)),
    );
  }
}
