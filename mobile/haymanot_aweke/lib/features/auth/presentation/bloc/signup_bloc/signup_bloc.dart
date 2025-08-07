import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/user_entity.dart';
import '../../../domain/usecases/signup.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase signupUsecase;

  SignupBloc({required this.signupUsecase})
      : super(const SignupFormState(
          isPasswordVisible: false,
          isConfirmPasswordVisible: false,
          isTermsAccepted: false,
        )) {

    on<SignupSubmitted>(_onSignupSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<ToggleTermsAcceptance>(_onToggleTermsAcceptance);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(const SignupLoading());

    try {
    
      if (event.password != event.confirmPassword) {
        emit(const SignupError(message: "Passwords don't match"));
        return;
      }

      final user = UserEntity(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      final result = await signupUsecase.call(user);
      result.fold(
        (failure) {
          emit(const SignupError(message: 'an error has occured'));
        },
        (_) {
          emit(const SignupSuccess(message: 'Account created successfully!'));
        },
      );

    } catch (error) {
      emit(SignupError(message: "An unexpected error occurred: ${error.toString()}"));
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<SignupState> emit,
  ) {
    final currentState = state;
    if (currentState is SignupFormState) {
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    } else {
      emit(const SignupFormState(isPasswordVisible: true));
    }
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<SignupState> emit,
  ) {
    final currentState = state;
    if (currentState is SignupFormState) {
      emit(currentState.copyWith(
        isConfirmPasswordVisible: !currentState.isConfirmPasswordVisible,
      ));
    } else {
      emit(const SignupFormState(isConfirmPasswordVisible: true));
    }
  }

  void _onToggleTermsAcceptance(
    ToggleTermsAcceptance event,
    Emitter<SignupState> emit,
  ) {
    final currentState = state;
    if (currentState is SignupFormState) {
      emit(currentState.copyWith(
        isTermsAccepted: !currentState.isTermsAccepted,
      ));
    } else {
      emit(const SignupFormState(isTermsAccepted: true));
    }
  }
}