import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SignUpUsecase {
  final UserRepository userRepository;

  SignUpUsecase({required this.userRepository});

  Future<UserEntity> call(
      {required String email, required String password}) async {
    if (email.isEmpty) throw const InvalidEmailFailure();
    if (password.length < 6) throw WeakPasswordFailure();

    return await userRepository.signUp(email: email, password: password);
  }
}
