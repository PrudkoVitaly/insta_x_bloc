import 'package:insta_x_bloc/core/utils/reg_ex.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository userRepository;

  SignUpUseCase({required this.userRepository});

  Future<UserEntity> call(
      {required String email, required String password, String? name}) async {
    if (name == null) {
      throw const InvalidInputFailure(errorMessage: 'Имя обязательно');
    }
    _validateSignUpData(email, password, name);

    return await userRepository.signUp(
        email: email, password: password, name: name);
  }

  void _validateSignUpData(String email, String password, String name) {
    final trimmedEmail = email.trim();
    final trimmedName = name.trim();

    if (trimmedEmail.isEmpty) {
      throw const InvalidEmailFailure('Email не может быть пустым');
    }

    if (!_isValidEmail(trimmedEmail)) {
      throw const InvalidEmailFailure('Неверный формат email');
    }

    if (password.isEmpty) {
      throw WeakPasswordFailure('Пароль не может быть пустым');
    }

    if (password.length < 8) {
      throw WeakPasswordFailure('Пароль должен содержать минимум 8 символов');
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      throw WeakPasswordFailure(
          'Пароль должен содержать хотя бы одну заглавную букву');
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      throw WeakPasswordFailure(
          'Пароль должен содержать хотя бы одну строчную букву');
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      throw WeakPasswordFailure('Пароль должен содержать хотя бы одну цифру');
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      throw WeakPasswordFailure(
          'Пароль должен содержать хотя бы один специальный символ');
    }

    if (trimmedName.isEmpty) {
      throw const InvalidInputFailure(errorMessage: 'Имя не может быть пустым');
    }

    if (trimmedName.length < 2) {
      throw const InvalidInputFailure(
          errorMessage: 'Имя должно содержать минимум 2 символа');
    }
  }

  bool _isValidEmail(String email) {
    return emailRegExp.hasMatch(email);
  }
}
