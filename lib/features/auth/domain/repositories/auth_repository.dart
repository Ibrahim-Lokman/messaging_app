abstract class AuthRepository {
  Future<String> login({required String email, required String password});
  Future<String> loginWithUsername({required String username, required String password});
  Future<String> signup({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  // Future<User?> getCurrentUser();
}
