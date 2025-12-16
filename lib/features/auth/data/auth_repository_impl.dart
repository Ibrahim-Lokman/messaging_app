import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/entities/user.dart' as auth_user;
import '../../../core/utils/result.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/failure.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<String>> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      
      if (user == null) {
        return ResultFailure(
          AuthFailure(
            message: 'Login succeeded but user data is unavailable',
            code: 'NULL_USER',
          ),
        );
      }
      
      return Success(user.uid);
    } on FirebaseAuthException catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Result<String>> loginWithUsername({required String username, required String password}) async {
    try {
      // Look up email from username
      final emailResult = await _getEmailFromUsername(username);
      
      if (emailResult.isFailure) {
        return ResultFailure(emailResult.getFailureOrNull()!);
      }
      
      final email = emailResult.getOrNull()!;
      
      // Use the existing login method with the retrieved email
      return await login(email: email, password: password);
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    }
  }

  Future<Result<String>> _getEmailFromUsername(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return ResultFailure(AuthFailure.userNotFound());
      }

      final userData = querySnapshot.docs.first.data();
      final email = userData['email'] as String?;
      
      if (email == null || email.isEmpty) {
        return ResultFailure(
          AuthFailure(
            message: 'Account data is incomplete. Please contact support.',
            code: 'INCOMPLETE_DATA',
          ),
        );
      }

      return Success(email);
    } on FirebaseException catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Result<String>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (username.trim().isEmpty) {
        return ResultFailure(
          ValidationFailure(
            message: 'Username cannot be empty',
            code: 'EMPTY_USERNAME',
          ),
        );
      }
      
      if (email.trim().isEmpty) {
        return ResultFailure(
          ValidationFailure(
            message: 'Email cannot be empty',
            code: 'EMPTY_EMAIL',
          ),
        );
      }
      
      if (password.length < 6) {
        return ResultFailure(AuthFailure.weakPassword());
      }
      
      // Check username uniqueness
      final usernameDoc = _firestore.collection('usernames').doc(username);
      
      final usernameSnapshot = await usernameDoc.get();
      if (usernameSnapshot.exists) {
        return ResultFailure(AuthFailure.usernameAlreadyTaken());
      }

      // Create Auth User
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return ResultFailure(
          AuthFailure(
            message: 'Account creation failed. Please try again.',
            code: 'USER_CREATION_FAILED',
          ),
        );
      }

      // Save User Data in a transaction-like manner
      try {
        // Save user data
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': null,
          'searchKeywords': _generateSearchKeywords(username),
        });

        // Reserve Username
        await usernameDoc.set({'uid': user.uid});
        
        return Success(user.uid);
      } catch (e) {
        // Rollback: Delete the auth user if Firestore operations fail
        await user.delete();
        rethrow;
      }
      
    } on FirebaseAuthException catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    } on FirebaseException catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.handleException(e, stackTrace));
    }
  }

  List<String> _generateSearchKeywords(String username) {
    List<String> temp = [];
    for (int i = 0; i < username.length; i++) {
      temp.add(username.substring(0, i + 1).toLowerCase());
    }
    return temp;
  }

  Future<auth_user.User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) return null;

      final data = userDoc.data();
      if (data == null) return null;

      return auth_user.User.fromMap({
        'uid': firebaseUser.uid,
        'username': data['username'] ?? '',
        'email': data['email'] ?? firebaseUser.email ?? '',
        'photoUrl': data['photoUrl'],
      });
    } catch (e) {
      return null;
    }
  }
}
