import '../entities/post.dart';

abstract class PostsRepository {
  Stream<List<Post>> getPosts();
  Future<void> createPost(String userId, String username, String? userPhotoUrl, String content);
  Future<void> deletePost(String postId);
}
