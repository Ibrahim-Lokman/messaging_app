import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/entities/message.dart';

class FirebaseChatRepository implements ChatRepository {
  final FirebaseFirestore _firestore;
  final Box? _box; // We might need to open box async

  FirebaseChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _box = null; 

  // Helper to open box lazily or assuming opened
  Future<Box> _getBox(String chatId) async {
    if (Hive.isBoxOpen('chat_$chatId')) {
      return Hive.box('chat_$chatId');
    }
    return await Hive.openBox('chat_$chatId');
  }

  String _getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Future<void> sendMessage(Message message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);
    
    // Optimistic Update: Save to local Hive first?
    final box = await _getBox(chatId);
    await box.put(message.id, message.toMap());

    // Send to Firestore
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
        
    // Update last message in Chat List (Optional but good for scalability)
  }

  @override
  Stream<List<Message>> getMessages(String currentUserId, String otherUserId) async* {
    final chatId = _getChatId(currentUserId, otherUserId);
    final box = await _getBox(chatId);

    // Initial Yield from Hive
    yield _getMessagesFromBox(box);

    // Watch Hive for local updates?
    // Or Listen to Firestore and update Hive?
    // Let's listen to Firestore -> Update Hive -> Yield Hive (or rely on Watch)
    
    final stream = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    stream.listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added || 
            change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null) {
            box.put(change.doc.id, data);
          }
        }
      }
    });
    
    // We yield the box stream
    yield* box.watch().map((event) {
      return _getMessagesFromBox(box);
    });
  }
  
  List<Message> _getMessagesFromBox(Box box) {
    final msgs = box.values.map((e) {
      // e is Map<dynamic, dynamic>, need valid Map<String, dynamic>
      final map = Map<String, dynamic>.from(e as Map);
      return Message.fromMap(map);
    }).toList();
    
    msgs.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Descending
    return msgs;
  }

  @override
  Future<void> syncMessages(String currentUserId, String otherUserId) async {
     // Implemented via listener in getMessages for now
  }
}
