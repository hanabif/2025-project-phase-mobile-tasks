import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repositories/signup_repositroy.dart';

class SignupUsecase {
  final SignupRepository repository;
  SignupUsecase(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.signup(user);
  }
}
