import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User?> get myUser;

  Future<UserEntity> signUp({required String email, required String password});

  Future<UserEntity> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<UserEntity> getMyUser(String userId);

  Future<void> setUserData(UserEntity user);
}
