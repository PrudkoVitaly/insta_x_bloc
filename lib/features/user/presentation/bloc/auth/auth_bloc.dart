import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/usecases/get_user_usecase.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/auth/auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserStreamUseCase userStreamUseCase;
  late final StreamSubscription<UserEntity?> _userSubscription;

  AuthenticationBloc({required this.userStreamUseCase})
      : super(const AuthenticationState.unknown()) {
    _userSubscription = userStreamUseCase.call().listen(
          (authUser) => add(AuthenticationUserChangedEvent(user: authUser!)),
          onError: (error) =>
              add(AuthenticationErrorEvent(message: error.toString())),
        );

    on<AuthenticationUserChangedEvent>((event, emit) {
      if (event.user != null && event.user!.isNotEmpty) {
        emit(AuthenticationState.authenticated(user: event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });

    on<AuthenticationErrorEvent>((event, emit) {
      emit(AuthenticationState.error(error: event.message));
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
