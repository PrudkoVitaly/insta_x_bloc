import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/sign_in_screen.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
