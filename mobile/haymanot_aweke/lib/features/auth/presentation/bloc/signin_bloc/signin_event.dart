import 'package:equatable/equatable.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SigninSubmitted extends SigninEvent {
  final String email;
  final String password;

  const SigninSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class TogglePasswordVisibility extends SigninEvent {}
