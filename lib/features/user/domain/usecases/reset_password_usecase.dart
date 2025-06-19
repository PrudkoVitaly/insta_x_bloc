import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class ResetPasswordUseCase {
  final UserRepository userRepository;

  ResetPasswordUseCase(this.userRepository);

  Future<void> call(String password) async {
    if (password.isEmpty)
      throw const InvalidEmailFailure('Пароль не может быть пустым');
    await userRepository.resetPassword(password);
  }
}
