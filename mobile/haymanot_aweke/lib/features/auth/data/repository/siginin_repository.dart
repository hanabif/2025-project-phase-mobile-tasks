import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/signin_repository.dart';
import '../datasource/user_local_datasource.dart';
import '../datasource/user_remote_datasource.dart';
import '../model/signin_model.dart';
import '../model/user_model.dart';

class SigninRepositoryImpl implements SigninRepository {
  final UserLocalDatasource userLocalDatasource;
  final UserRemoteDatasource userRemoteDatasource;
  final NetworkInfo networkInfo;

  SigninRepositoryImpl({
    required this.userLocalDatasource,
    required this.userRemoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> signin(UserEntity credentials) async {
    print('🏪 SigninRepository: signin method called');
    print('🏪 SigninRepository: Email: ${credentials.email}');

    try {
      // final isConnected = await networkInfo.isConnected;
      // print('Repository: isConnected? $isConnected');
      // if (!isConnected) {
      //   return Left(NetworkFailure());
      // }
    } catch (networkError) {
      print('SigninRepository: Network check failed: $networkError');
    }

    try {
      print('✅ Repository: Attempting to sign in...');
      final userModel = UserModel(
        name: '', // Empty for signin
        email: credentials.email,
        password: credentials.password,
      );

      final accessToken = await userRemoteDatasource.signIn(userModel);
      print('SigninRepository: received access token: $accessToken');

      try {
        await userLocalDatasource.saveToken(accessToken);
      } catch (cacheError) {
        print(
          'SigninRepository: Token storage warning (non-critical): $cacheError',
        );
      }
      print('🎉 SigninRepository: Signin process completed successfully!');
      return Right(accessToken);
    } on FormatException catch (e) {
      return const Left(ServerFailure());
    } 
      // } if (errorMessage.contains('invalid credentials') ||
      //     errorMessage.contains('unauthorized') ||
      //     errorMessage.contains('sign in failed') ||
      //     errorMessage.contains('login failed') ||
      //     errorMessage.contains('authentication failed')) {
      //   return const Left(ServerFailure());
      // } else if (errorMessage.contains('user not found') ||
      //     errorMessage.contains('account not found')) {
      //   return const Left(ServerFailure());
      // } else {
      //   return const Left(ServerFailure());
      // }
    // }
  }
}
