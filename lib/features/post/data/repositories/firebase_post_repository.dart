// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:insta_x_bloc/features/post/data/models/post_model.dart';
// import 'package:insta_x_bloc/features/post/domain/entities/post.dart';
// import 'package:insta_x_bloc/features/post/domain/repositories/post_repository.dart';

// class FirebasePostRepository implements PostRepository {
//   final FirebaseFirestore? _firestore;
//   final FirebaseAuth? _auth;

//   FirebasePostRepository({
//     FirebaseFirestore? firestore,
//     FirebaseAuth? auth,
//   })  : _firestore = firestore,
//         _auth = auth;

//   @override
//   Future<List<PostEntity>> getPosts() async {
//     try {
//       final post = _firestore!
//           .collection("posts")
//           .orderBy("createdAt", descending: true);

//       final postSnapshot = await post.get();

//       final posts = postSnapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         data['id'] = doc.id;
//         return PostModel.fromJson(data).toEntity();
//       }).toList();

//       return posts;
//     } catch (e) {
//       throw Exception('Failed to get posts: $e');
//     }
//   }

//   @override
//   Future<PostEntity> createPost({required PostEntity post}) async {
//     try {
//       final user = _auth!.currentUser;

//       print('DEBUG: Current user in repo: $user');

//       if (user == null) {
//         throw Exception('User not authenticated');
//       }

//       final now = DateTime.now();

//       final postData = {
//         'id': '',
//         'title': post.title,
//         'content': post.content,
//         'userId': user.uid,
//         'createdAt': now.toIso8601String(),
//         'updatedAt': now.toIso8601String(),
//       };

//       final postDoc = await _firestore!.collection("posts").add(postData);

//       postData['id'] = postDoc.id;

//       return PostModel.fromJson(postData).toEntity();
//     } catch (e) {
//       throw Exception('Failed to create post: $e');
//     }
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:insta_x_bloc/features/post/domain/entities/post.dart';
import 'package:insta_x_bloc/features/post/domain/repositories/post_repository.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<PostEntity> createPost({required PostEntity post}) async {
    try {
      final postId = const Uuid().v1();
      final createdAt = DateTime.now();

      String? imageUrl;
      if (post.imageUrl != null) {
        imageUrl = await uploadPostImage(
            imageFile: File(post.imageUrl!), postId: postId);
      }

      await postCollection.doc(postId).set({
        'id': postId,
        'title': post.title,
        'content': post.content,
        'userId': post.userId,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
      });

      return PostEntity(
        id: postId,
        title: post.title,
        content: post.content,
        userId: post.userId,
        createdAt: createdAt.toIso8601String(),
        updatedAt: createdAt.toIso8601String(),
        imageUrl: imageUrl,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<PostEntity>> getPosts() {
    try {
      return postCollection.get().then((value) => value.docs
          .map((e) => PostEntity(
                id: e.data()['id'],
                title: e.data()['title'],
                content: e.data()['content'],
                userId: e.data()['userId'],
                createdAt: (e.data()['createdAt'] is Timestamp)
                    ? (e.data()['createdAt'] as Timestamp)
                        .toDate()
                        .toIso8601String()
                    : e.data()['createdAt'] ?? '',
                updatedAt: (e.data()['updatedAt'] is Timestamp)
                    ? (e.data()['updatedAt'] as Timestamp)
                        .toDate()
                        .toIso8601String()
                    : e.data()['updatedAt'] ?? '',
                imageUrl: e.data()['imageUrl'],
              ))
          .toList());
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  @override
  Future<String> uploadPostImage(
      {required File imageFile, required String postId}) async {
    final ref = FirebaseStorage.instance.ref().child('post_images/$postId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
