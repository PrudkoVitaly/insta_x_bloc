import 'package:equatable/equatable.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationInitialState extends Equatable {
  const AuthenticationInitialState();
  @override
  List<Object?> get props => [];
}

class AuthenticationState extends AuthenticationInitialState {
  final AuthenticationStatus status;
  final UserEntity? user;
  final String? error;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.error,
  });

  // Состояние по умолчанию (неизвестно)
  const AuthenticationState.unknown() : this._();

  // Пользователь аутентифицирован
  const AuthenticationState.authenticated({required UserEntity user})
      : this._(status: AuthenticationStatus.authenticated, user: user);

  // Пользователь не аутентифицирован
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  // Ошибка аутентификации
  const AuthenticationState.error({required String error})
      : this._(status: AuthenticationStatus.unauthenticated, error: error);

  // Удобные геттеры для UI
  bool get isAuthenticated => status == AuthenticationStatus.authenticated;
  bool get isUnauthenticated => status == AuthenticationStatus.unauthenticated;
  bool get isUnknown => status == AuthenticationStatus.unknown;
  bool get hasError => error != null && error!.isNotEmpty;

  @override
  List<Object?> get props => [status, user, error];
}
