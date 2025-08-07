import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String password;
  final String email;
  final String confirmPassword;

  const SignupSubmitted({
    required this.name,
    required this.confirmPassword,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, password, confirmPassword, email];
}

class TogglePasswordVisibility extends SignupEvent{

}

class ToggleConfirmPasswordVisibility extends SignupEvent{}

class ToggleTermsAcceptance extends SignupEvent{}