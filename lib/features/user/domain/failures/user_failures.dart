import 'package:equatable/equatable.dart';

abstract class UserFailures extends Equatable {
  const UserFailures();

  String get message;

  @override
  List<Object?> get props => [];
}

class EmailAlreadyInUseFailure extends UserFailures {
  @override
  String get message => "Этот адрес электронной почты уже используется.";
}

class WeakPasswordFailure extends UserFailures {
  WeakPasswordFailure(String s);

  @override
  String get message => "Пароль слишком слабый.";
}

class InvalidEmailFailure extends UserFailures {
  const InvalidEmailFailure(String message);
  @override
  String get message => "Недействительный адрес электронной почты.";
}

class UserNotFoundFailure extends UserFailures {
  const UserNotFoundFailure();
  @override
  String get message => "Пользователь не найден.";
}

class WrongPasswordFailure extends UserFailures {
  const WrongPasswordFailure();
  @override
  String get message => "Неверный пароль.";
}

class UnknownUserFailure extends UserFailures {
  final String? errorMessage;
  const UnknownUserFailure([this.errorMessage]);
  @override
  String get message =>
      errorMessage ?? "Произошла неизвестная ошибка с пользователем.";

  @override
  List<Object?> get props => [errorMessage];
}

class InvalidInputFailure extends UserFailures {
  final String errorMessage;
  const InvalidInputFailure({required this.errorMessage});
  @override
  String get message => errorMessage;
}

class UploadPictureFailure implements Exception {
  final String message;
  UploadPictureFailure({required this.message});
  @override
  String toString() => 'UploadFailure: $message';
}

class MyUserFailure implements Exception {
  final String message;
  MyUserFailure({required this.message});
  @override
  String toString() => 'MyUserFailure: $message';
}
