import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_x_bloc/features/post/presentation/bloc/post_bloc.dart';
import 'package:insta_x_bloc/features/post/presentation/bloc/post_state.dart';
import 'package:insta_x_bloc/features/post/presentation/screens/post_screen.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/my_user/my_user_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/my_user/my_user_state.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/update_user_info/update_user_info_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/update_user_info/update_user_info_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImageUrl;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 100,
                        );
                        if (image != null) {
                          final croppedFile = await ImageCropper().cropImage(
                            sourcePath: image.path,
                            aspectRatio:
                                const CropAspectRatio(ratioX: 1, ratioY: 1),
                            aspectRatioPresets: [CropAspectRatioPreset.square],
                            uiSettings: [
                              AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor:
                                    Theme.of(context).colorScheme.primary,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false,
                              ),
                              IOSUiSettings(title: 'Cropper'),
                            ],
                          );
                          if (croppedFile != null) {
                            context.read<UpdateUserInfoBloc>().add(
                                  UploadPictureEvent(
                                    file: File(croppedFile.path),
                                    userId: context
                                        .read<MyUserBloc>()
                                        .state
                                        .user!
                                        .id,
                                  ),
                                );
                          }
                        }
                      },
                      child: state.user!.picture != null &&
                              state.user!.picture != ""
                          ? Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(state.user!.picture!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(CupertinoIcons.person,
                                  color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Text("Welcome ${state.user!.name}")
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoadedState) {
              final posts = state.posts;
              if (posts.isEmpty) {
                return Center(child: Text('No posts yet'));
              }
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: post.imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(post.imageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/default_image.png'),
                                            fit: BoxFit.cover,
                                          ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(post.createdAt.substring(
                                        0, 10)), // или форматируйте дату
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(post.content),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is PostErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Container();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PostScreen()));
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
