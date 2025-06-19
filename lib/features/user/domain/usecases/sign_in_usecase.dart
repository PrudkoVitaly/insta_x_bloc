import 'package:insta_x_bloc/core/utils/reg_ex.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SignInUseCase {
  final UserRepository userRepository;

  SignInUseCase({required this.userRepository});

  Future<UserEntity> call(
      {required String email, required String password}) async {
    _validateSignInData(email, password);

    return await userRepository.signIn(email: email, password: password);
  }

  void _validateSignInData(String email, String password) {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      throw const InvalidEmailFailure('Email не может быть пустым');
    }

    if (!_isValidEmail(trimmedEmail)) {
      throw const InvalidEmailFailure('Неверный формат email');
    }

    if (password.isEmpty) {
      throw WeakPasswordFailure('Пароль не может быть пустым');
    }

    if (password.length < 6) {
      throw WeakPasswordFailure('Пароль должен содержать минимум 6 символов');
    }
  }

  bool _isValidEmail(String email) {
    return emailRegExp.hasMatch(email);
  }
}
