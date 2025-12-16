import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final String? error;

  const ChatLoaded({this.messages = const [], this.error});

  @override
  List<Object?> get props => [messages, error];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}
