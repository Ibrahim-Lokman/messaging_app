import '../../../auth/domain/entities/user.dart';

abstract class ContactsRepository {
  Future<User?> searchUserByUsername(String username);
  Future<void> addFriend(String currentUserId, String friendId);
  Stream<List<User>> getFriends(String currentUserId);
}
