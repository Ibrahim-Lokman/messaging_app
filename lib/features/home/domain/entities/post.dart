import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String content;
  final DateTime timestamp;

  const Post({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, userId, username, userPhotoUrl, content, timestamp];

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
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
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
