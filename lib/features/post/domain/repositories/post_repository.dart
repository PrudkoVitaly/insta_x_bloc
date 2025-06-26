import 'dart:io';

import 'package:insta_x_bloc/features/post/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();

  Future<PostEntity> createPost({required PostEntity post});

  Future<String> uploadPostImage(
      {required File imageFile, required String postId});
}
