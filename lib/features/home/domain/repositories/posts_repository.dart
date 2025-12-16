import '../entities/post.dart';
import '../entities/comment.dart';

abstract class PostsRepository {
  Stream<List<Post>> getPosts();
  Future<void> createPost(String userId, String username, String? userPhotoUrl, String content);
  Future<void> deletePost(String postId);
  
  // Comment operations
  Stream<List<Comment>> getComments(String postId);
  Future<void> addComment(String postId, String userId, String username, String? userPhotoUrl, String content);
  Future<void> deleteComment(String postId, String commentId);
}
