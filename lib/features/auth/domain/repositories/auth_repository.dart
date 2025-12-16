import '../../../../core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<String>> login({required String email, required String password});
  Future<Result<String>> loginWithUsername({required String username, required String password});
  Future<Result<String>> signup({
    required String username,
    required String email,
    required String password,
  });
  Future<Result<void>> logout();
  // Future<User?> getCurrentUser();
}
