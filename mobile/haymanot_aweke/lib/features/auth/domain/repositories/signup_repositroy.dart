import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';

abstract class SignupRepository {
  Future<Either<Failure, void>> signup(UserEntity user);
}
