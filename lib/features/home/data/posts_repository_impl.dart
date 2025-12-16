import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/post.dart';
import '../domain/repositories/posts_repository.dart';

class FirebasePostsRepository implements PostsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  @override
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }

  @override
  Future<void> createPost(
    String userId,
    String username,
    String? userPhotoUrl,
    String content,
  ) async {
    final postId = _uuid.v4();
    await _firestore.collection('posts').doc(postId).set({
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
