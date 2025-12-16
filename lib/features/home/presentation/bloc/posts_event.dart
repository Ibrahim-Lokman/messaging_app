import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostsEvent {}

class CreatePost extends PostsEvent {
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String content;

  const CreatePost({
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.content,
  });

  @override
  List<Object?> get props => [userId, username, userPhotoUrl, content];
}

class DeletePost extends PostsEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}
