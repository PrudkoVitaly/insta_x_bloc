import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_state.dart';
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
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
