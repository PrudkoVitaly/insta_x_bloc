import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? picture,
  }) : super(
          id: id,
          name: name,
          email: email,
          picture: picture,
        );

  /// Create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String?,
    );
  }

  /// Convert a UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'picture': picture,
    };
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      picture: user.photoURL,
    );
  }

  // /// Convert a UserModel to a User entity
  // User toEntity() {
  //   return User(
  //     id: id,
  //     email: email,
  //     name: name,
  //     picture: picture,
  //   );
  // }

  /// Create a UserModel from a User entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      picture: entity.picture,
    );
  }
}
