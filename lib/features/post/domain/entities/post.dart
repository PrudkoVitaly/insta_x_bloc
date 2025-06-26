import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String userId;
  final String createdAt;
  final String updatedAt;
  final String? imageUrl;
  final String? userAvatarUrl;
  PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.userAvatarUrl,
  });

  static PostEntity empty = PostEntity(
    id: '',
    title: '',
    content: '',
    userId: '',
    createdAt: '',
    updatedAt: '',
    imageUrl: '',
    userAvatarUrl: '',
  );

  PostEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? userId,
    String? createdAt,
    String? updatedAt,
    String? imageUrl,
    String? userAvatarUrl,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }

  bool get isEmpty => this == PostEntity.empty;

  bool get isNotEmpty => this != PostEntity.empty;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        userId,
        createdAt,
        updatedAt,
        imageUrl,
        userAvatarUrl
      ];
}
