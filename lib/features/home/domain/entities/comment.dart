import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String content;
  final DateTime timestamp;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, postId, userId, username, userPhotoUrl, content, timestamp];

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String?,
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
