import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/app/app_view.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/get_user_usecase.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';

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
                    UserStreamUseCase(userRepository: userRepository))),
      ],
      child: AppView(),
    );
  }
}
