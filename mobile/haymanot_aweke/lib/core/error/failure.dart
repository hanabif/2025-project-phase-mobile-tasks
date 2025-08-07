import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(); 

  @override
  List<Object?> get props => [];
}

//General Failures
class ServerFailure extends Failure {
  final String message;
  const ServerFailure([this.message = 'Server Failure']);
  @override
  List<Object?> get props => [message];
}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure{
  final String message;

  const NetworkFailure([this.message = 'No network connection detected.']);

  @override
  List<Object?> get props => [message];
}

//auth specific features
class invalidCredentialsFailure extends Failure{
  final String message;

  invalidCredentialsFailure({required this.message});
}
class EmailAreadyExistsFailure extends Failure{
  final String message;

  EmailAreadyExistsFailure({required this.message});
  
}