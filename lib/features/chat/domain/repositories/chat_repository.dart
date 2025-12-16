import '../entities/message.dart';

abstract class ChatRepository {
  Future<void> sendMessage(Message message);
  Stream<List<Message>> getMessages(String currentUserId, String otherUserId);
  Future<void> syncMessages(String currentUserId, String otherUserId);
}
