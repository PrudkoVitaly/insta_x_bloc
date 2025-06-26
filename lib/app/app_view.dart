import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/features/post/domain/repositories/post_repository.dart';
import 'package:insta_x_bloc/features/post/domain/usecases/create_post_usecase.dart';
import 'package:insta_x_bloc/features/post/domain/usecases/get_post_usecase.dart';
import 'package:insta_x_bloc/features/post/presentation/bloc/post_bloc.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/my_user_usecase.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/update_user_Info_usecase.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_state.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/my_user/my_user_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/my_user/my_user_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/home_screen.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/welcome_screen.dart';
import 'package:insta_x_bloc/theme/theme.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InstaX',
      theme: appTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                      signInUseCase: SignInUseCase(
                          userRepository: context.read<UserRepository>()),
                      authBloc: context.read<AuthenticationBloc>()),
                ),
                BlocProvider(
                  create: (context) => UpdateUserInfoBloc(
                    updateUserInfoUseCase: UpdateUserInfoUseCase(
                        userRepository: context.read<UserRepository>()),
                  ),
                ),
                BlocProvider(
                  create: (context) => MyUserBloc(
                      myUserUseCase: MyUserUseCase(
                          myUserRepository: context.read<UserRepository>()))
                    ..add(GetMyUser(myUserId: state.user!.id)),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
