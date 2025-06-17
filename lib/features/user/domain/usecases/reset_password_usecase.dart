import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class ResetPasswordUseCase {
  final UserRepository userRepository;

  ResetPasswordUseCase(this.userRepository);

  Future<void> call(String email) async {
    if (email.isEmpty) throw const InvalidEmailFailure();
    await userRepository.resetPassword(email);
  }
}
