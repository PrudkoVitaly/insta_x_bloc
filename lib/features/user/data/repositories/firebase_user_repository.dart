import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_x_bloc/features/user/data/models/user_model.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth;
  final CollectionReference usersCollection;

  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        usersCollection = FirebaseFirestore.instance.collection("users");

  @override
  Stream<UserEntity?> get myUser {
    return _auth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return UserModel.fromFirebaseUser(user!);
    });
  }

  @override
  Future<UserEntity> signUp(
      {required String email, required String password, String? name}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const UnknownUserFailure(
            'Пользователь является нулевым после регистрации');
      }
      // Создаём UserEntity
      final userEntity = UserEntity(
        id: user.uid,
        name: name ?? '',
        email: user.email ?? '',
        picture: '',
      );

      // Сохраняем пользователя в Firestore
      await setUserData(userEntity);

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseFailure();
      }
      if (e.code == 'weak-password') {
        throw WeakPasswordFailure('Пароль слишком слабый');
      }
      if (e.code == 'invalid-email') {
        throw const InvalidEmailFailure('Неверный формат email');
      }
      throw UnknownUserFailure(e.message ?? 'Неизвестная ошибка регистрации');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> signIn(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const UserNotFoundFailure();
      }

      // Проверяем, есть ли документ пользователя в Firestore
      final doc = await usersCollection.doc(user.uid).get();
      if (!doc.exists) {
        final userEntity = UserEntity(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          picture: '',
        );
        await setUserData(userEntity);
      }

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UserNotFoundFailure();
      }
      if (e.code == 'wrong-password') {
        throw const WrongPasswordFailure();
      }
      if (e.code == 'invalid-email') {
        throw const InvalidEmailFailure('Неверный формат email');
      }
      if (e.code == 'user-disabled') {
        throw const UnknownUserFailure();
      }
      throw UnknownUserFailure(e.message ?? 'Неизвестная ошибка входа');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw UnknownUserFailure(e.message ?? 'Ошибка выхода из аккаунта');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UserNotFoundFailure();
      }
      if (e.code == 'invalid-email') {}
      throw UnknownUserFailure(e.message ?? 'Неизвестная ошибка сброса пароля');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> getMyUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();

      if (!doc.exists || doc.data() == null) throw const UserNotFoundFailure();

      final userModel = UserModel.fromJson(doc.data()! as Map<String, dynamic>);
      return userModel;
    } on FirebaseException catch (e) {
      throw UnknownUserFailure(e.message ?? 'Ошибка получения пользователя');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<void> setUserData(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await usersCollection.doc(user.id).set(userModel.toJson());
    } on FirebaseException catch (e) {
      throw UnknownUserFailure(
          e.message ?? 'Ошибка сохранения данных пользователя');
    } catch (e) {
      throw UnknownUserFailure(e.toString());
    }
  }

  @override
  Future<String> uploadPicture(
      {required String userId, required String file}) async {
    try {
      final imageFile = File(file);
      final firebaseStoreRef =
          FirebaseStorage.instance.ref().child('userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      throw UploadPictureFailure(message: e.toString());
    }
  }
}
