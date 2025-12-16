import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription? _messagesSubscription;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<ChatLoadMessages>(_onLoadMessages);
    on<ChatSendMessage>(_onSendMessage);
    on<_ChatUpdated>(_onChatUpdated);
  }

  Future<void> _onLoadMessages(
    ChatLoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    await _messagesSubscription?.cancel();
    _messagesSubscription = chatRepository
        .getMessages(event.currentUserId, event.otherUserId)
        .listen((messages) {
      add(_ChatUpdated(messages));
    });
  }

  void _onChatUpdated(_ChatUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(messages: event.messages));
  }

  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = Message(
        id: const Uuid().v4(),
        senderId: event.currentUserId,
        receiverId: event.otherUserId,
        text: event.text,
        timestamp: DateTime.now(),
      );
      await chatRepository.sendMessage(message);
    } catch (e) {
      // In a real app we might handle optimistic failure
      // emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}

class _ChatUpdated extends ChatEvent {
  final List<Message> messages;
  const _ChatUpdated(this.messages);
}
