import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  String? picture;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.picture,
  });

  /// Empty user
  static UserEntity empty = UserEntity(
    id: '',
    name: '',
    email: '',
    picture: "",
  );

  /// Copy with User
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? picture,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      picture: picture ?? this.picture,
    );
  }

  /// Returns true if the user is empty
  bool get isEmpty => this == UserEntity.empty;

  /// Returns true if the user is not empty
  bool get isNotEmpty => this != UserEntity.empty;

  /// Returns a string representation of the user
  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, picture: $picture)';
  }

  @override
  List<Object?> get props => [id, name, email, picture];
}
