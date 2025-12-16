class Profile {
  final String id;
  final String username;
  final String email;
  final String? photoUrl;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  Profile copyWith({
    String? id,
    String? username,
    String? email,
    String? photoUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
