import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class ChatLoadMessages extends ChatEvent {
  final String currentUserId;
  final String otherUserId;
  const ChatLoadMessages(this.currentUserId, this.otherUserId);
}

class ChatSendMessage extends ChatEvent {
  final String currentUserId;
  final String otherUserId;
  final String text;
  const ChatSendMessage(this.currentUserId, this.otherUserId, this.text);
}
