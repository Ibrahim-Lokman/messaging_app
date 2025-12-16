import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/post.dart';
import '../domain/entities/comment.dart';
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
      'commentCount': 0,
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    // Delete the post
    await _firestore.collection('posts').doc(postId).delete();
    
    // Delete all comments for this post
    final commentsSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();
    
    for (var doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Comment.fromMap({...data, 'id': doc.id, 'postId': postId});
      }).toList();
    });
  }

  @override
  Future<void> addComment(
    String postId,
    String userId,
    String username,
    String? userPhotoUrl,
    String content,
  ) async {
    final commentId = _uuid.v4();
    
    // Run as a transaction to ensure consistency if needed, 
    // but basic batch/mult-path update is fine for now.
    // We'll use simple sequential awaits here for simplicity and standard firestore usage.
    
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Increment comment count on the post
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();

    // Decrement comment count on the post
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(-1),
    });
  }
}
