import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../domain/entity/user_entity.dart';
import '../../../domain/usecases/login.dart';

import 'signin_event.dart';
import 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninUsecase signinUsecase;

  SigninBloc({required this.signinUsecase})
    : super(const SigninPasswordVisibilityToggled(isPasswordVisible: false)) {
    on<SigninSubmitted>(_onSigninSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onSigninSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(SigninLoading());
    try {
      final credentials = UserEntity(
        name: '',
        email: event.email,
        password: event.password,
      );

      final result = await signinUsecase.call(credentials);
      result.fold(
        (failure) {
          emit(SigninFailure(message: 'failure.message'));
        },
        (token) async {
          emit(const SigninSuccess(message: "Welcome! Sign in successful"));
        },
      );
    } catch (error) {
      emit(
        SigninFailure(
          message: "An unexpected error occurred: ${error.toString()}",
        ),
      
      );
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<SigninState> emit,
  ) {
    final currentState = state;
    if (currentState is SigninPasswordVisibilityToggled) {
      emit(
        currentState.copyWith(
          isPasswordVisible: !currentState.isPasswordVisible,
        ),
      );
    } else {
      emit(const SigninPasswordVisibilityToggled(isPasswordVisible: true));
    }
  }
}