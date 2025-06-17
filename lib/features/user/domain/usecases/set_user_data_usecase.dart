import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class SetUserDataUseCase {
  final UserRepository userRepository;

  SetUserDataUseCase(this.userRepository);

  Future<void> call(UserEntity user) async {
    await userRepository.setUserData(user);
  }
}
