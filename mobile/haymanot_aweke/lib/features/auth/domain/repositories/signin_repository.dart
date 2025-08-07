import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/model/signin_model.dart';
import '../entity/user_entity.dart';

abstract class SigninRepository {
  Future<Either<Failure, String>> signin(UserEntity credentials);
}
