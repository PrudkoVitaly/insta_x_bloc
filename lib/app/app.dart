import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/app/app_view.dart';
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
  const MainApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthenticationBloc(
                userStreamUseCase:
                    UserStreamUseCase(userRepository: userRepository),
                signOutUseCase:
                    SignOutUseCase(userRepository: userRepository))),
        BlocProvider(
            create: (context) => SignInBloc(
                  signInUseCase: SignInUseCase(userRepository: userRepository),
                  authBloc: context.read<AuthenticationBloc>(),
                )),
        BlocProvider(
            create: (context) => SignUpBloc(
                  signUpUseCase: SignUpUseCase(userRepository: userRepository),
                  authBloc: context.read<AuthenticationBloc>(),
                )),
      ],
      child: AppView(),
    );
  }
}
