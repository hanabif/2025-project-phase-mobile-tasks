import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final String message;
  
  const SignupSuccess({required this.message});
  
  @override
  List<Object> get props => [message];
}

class SignupError extends SignupState {
  final String message;
  
  const SignupError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class SignupFormState extends SignupState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;
  
  const SignupFormState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsAccepted = false,
  });
  
  SignupFormState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsAccepted,
  }) {
    return SignupFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
  
  @override
  List<Object> get props => [
    isPasswordVisible,
    isConfirmPasswordVisible,
    isTermsAccepted,
  ];
}