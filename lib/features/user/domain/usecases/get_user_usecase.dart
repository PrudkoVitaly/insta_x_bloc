import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/domain/repositories/user_repository.dart';

class UserStreamUseCase {
  final UserRepository userRepository;

  UserStreamUseCase({required this.userRepository});

  Stream<UserEntity?> call() {
    return userRepository.myUser;
  }
}
