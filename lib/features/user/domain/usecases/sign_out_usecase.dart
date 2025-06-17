import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SignOutUseCase {
  final UserRepository userRepository;

  SignOutUseCase(this.userRepository);

  Future<void> call() async {
    await userRepository.signOut();
  }
}
