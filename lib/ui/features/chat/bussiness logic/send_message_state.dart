import '../../../../data/models/room_messages_response_model.dart';

abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final MessageItemModel message;

  SendMessageSuccess(this.message);
}

class SendMessageError extends SendMessageState {
  final String error;

  SendMessageError(this.error);
}
