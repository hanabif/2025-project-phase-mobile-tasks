import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repositories/signin_repository.dart';

class SigninUsecase {
  final SigninRepository signinRepository;

  SigninUsecase({required this.signinRepository});

  Future<Either<Failure, String>> call(UserEntity credentials) {
    return signinRepository.signin(credentials);
  }
}
