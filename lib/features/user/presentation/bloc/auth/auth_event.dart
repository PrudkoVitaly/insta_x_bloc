import 'package:equatable/equatable.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object?> get props => [];
}

class AuthenticationUserChangedEvent extends AuthenticationEvent {
  final UserEntity? user;
  const AuthenticationUserChangedEvent({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthenticationErrorEvent extends AuthenticationEvent {
  final String message;
  const AuthenticationErrorEvent({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
