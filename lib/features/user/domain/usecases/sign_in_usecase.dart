import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/failures/user_failures.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SignInUsecase {
  final UserRepository userRepository;

  SignInUsecase({required this.userRepository});

  Future<UserEntity> call(
      {required String email, required String password}) async {
    if (email.isEmpty) throw const InvalidEmailFailure();
    if (password.length < 6) throw WeakPasswordFailure();

    return await userRepository.signIn(email: email, password: password);
  }
}
