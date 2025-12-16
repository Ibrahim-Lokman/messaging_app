import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/repositories/contacts_repository.dart';
import '../../auth/domain/entities/user.dart';

class FirebaseContactsRepository implements ContactsRepository {
  final FirebaseFirestore _firestore;

  FirebaseContactsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> searchUserByUsername(String username) async {
    // 1. Check usernames map to find UID
    final usernameDoc = await _firestore.collection('usernames').doc(username).get();
    if (!usernameDoc.exists) return null;

    final data = usernameDoc.data();
    if (data == null) return null;
    final uid = data['uid'] as String;

    // 2. Fetch User Profile
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (!userDoc.exists) return null;

    return User.fromMap(userDoc.data()!);
  }

  @override
  Future<void> addFriend(String currentUserId, String friendId) async {
    // Add friendId to current user's friends collection
    // We store minimal info or just ID. Storing ID is safer for consistency.
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(friendId)
        .set({'addedAt': FieldValue.serverTimestamp()});
    
    // Also add current user to friend's friends collection (Mutual) or request?
    // Requirement says "user can add user". Let's assume one-way or auto-accept for simplicity
    // But usually chat requires mutual. Let's do mutual for now.
    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(currentUserId)
        .set({'addedAt': FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<User>> getFriends(String currentUserId) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      final friendIds = snapshot.docs.map((d) => d.id).toList();
      if (friendIds.isEmpty) return [];

      // Firestore "IN" query is limited to 10 or 30 items.
      // Ideally we fetch profiles one by one or batch.
      // For scalability, we should replicate basic friend info in the 'friends' subcollection.
      // But for this task, let's fetch individual/chunks.
      
      final List<User> friends = [];
      // Optimization: Future.wait
      // Note: This is read-heavy. Better to store {username, photo} in friend doc.
      final futures = friendIds.map((uid) => 
        _firestore.collection('users').doc(uid).get()
      );
      
      final docs = await Future.wait(futures);
      for (var doc in docs) {
        if (doc.exists && doc.data() != null) {
          friends.add(User.fromMap(doc.data()!));
        }
      }
      return friends;
    });
  }
}
