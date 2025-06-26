import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/app/app_view.dart';
import 'package:insta_x_bloc/features/post/domain/repositories/post_repository.dart';
import 'package:insta_x_bloc/features/post/domain/usecases/create_post_usecase.dart';
import 'package:insta_x_bloc/features/post/domain/usecases/get_post_usecase.dart';
import 'package:insta_x_bloc/features/post/presentation/bloc/post_bloc.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/get_user_usecase.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/sign_in_out_usecase.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_up/sign_up_bloc.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;
  final PostRepository postRepository;
  const MainApp(
      {super.key, required this.userRepository, required this.postRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: userRepository,
        ),
        RepositoryProvider<PostRepository>.value(
          value: postRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthenticationBloc(
                  userStreamUseCase:
                      UserStreamUseCase(userRepository: userRepository),
                  signOutUseCase:
                      SignOutUseCase(userRepository: userRepository))),
          BlocProvider(
              create: (context) => SignInBloc(
                    signInUseCase:
                        SignInUseCase(userRepository: userRepository),
                    authBloc: context.read<AuthenticationBloc>(),
                  )),
          BlocProvider(
              create: (context) => SignUpBloc(
                    signUpUseCase:
                        SignUpUseCase(userRepository: userRepository),
                    authBloc: context.read<AuthenticationBloc>(),
                  )),
          BlocProvider(
            create: (context) => PostBloc(
              GetPostUsecase(
                context.read<PostRepository>(),
              ),
              CreatePostUsecase(
                context.read<PostRepository>(),
              ),
            ),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}
