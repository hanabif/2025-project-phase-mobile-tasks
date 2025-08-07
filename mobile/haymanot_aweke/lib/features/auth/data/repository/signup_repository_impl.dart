import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/signup_repositroy.dart';
import '../datasource/user_remote_datasource.dart';
import '../model/user_model.dart';



class SignupRepositoryImpl implements SignupRepository {
 
  final UserRemoteDatasource userRemoteDatasource;
  final NetworkInfo networkInfo;

  SignupRepositoryImpl({
    
    required this.userRemoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> signup(UserEntity user) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      print('❌ Repository: No network connection detected');
      return const Left(
        NetworkFailure(
          //  message:
          //     'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      print('✅ Repository: Network connection confirmed');

      final userModel = UserModel(
        name: user.name,
        email: user.email,
        password: user.password,
      );
      final result = await userRemoteDatasource.signUp(userModel);
      return const Right(null);
    } on SocketException catch (e) {
      return const Left(
        NetworkFailure(
          // message: 'Connection failed. Please check your internet connection.',
        ),
      );
    } on HttpException catch (e) {
      return const Left(
        NetworkFailure(
          // message: 'Network request failed. Please try again.'
          ),
      );
    } on FormatException catch (e) {
      return const Left(
        ServerFailure(
          // message: 'Invalid response from server. Please try again.',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      print('💥 Repository: Lowercase error message: $errorMessage');

      if (errorMessage.contains('network error') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout') ||
          errorMessage.contains('socket')) {
        print('❌ Repository: Classified as network error');
        return const Left(
          NetworkFailure(
            //message: 'Connection problem. Please check your internet.',
          ),
        );
      } else if (errorMessage.contains('email already exists') ||
          errorMessage.contains('already registered')) {
        return const Left(
          ServerFailure(
            //message:
                'Email address is already registered. Please use a different email.',
          ),
        );
      } else if (errorMessage.contains('invalid email')) {
        print('❌ Repository: Classified as invalid email error');
        return const Left(
          ServerFailure(//message: 'Please provide a valid email address.'
          ),
        );
      } else if (errorMessage.contains('password')) {
        print('❌ Repository: Classified as password error');
        return const Left(
          ServerFailure(
            //message: 'Password does not meet security requirements.',
          ),
        );
      } else {
        return const Left(
          ServerFailure(
            // message: 'Account creation failed. Please try again.'
          ),
        );
      }
    }
  }

}