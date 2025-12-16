import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String? photoUrl;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, username, email, photoUrl];

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
