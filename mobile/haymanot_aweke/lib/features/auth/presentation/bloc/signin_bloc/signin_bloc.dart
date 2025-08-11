// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/user_entity.dart';
import '../../../domain/usecases/login.dart';
import 'signin_event.dart';
import 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninUsecase signinUsecase;
  bool isPasswordVisible = false;

  SigninBloc({required this.signinUsecase}) : super(SigninInitial()) {
    on<SigninSubmitted>((
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
            print('Signin failed: $failure');
            emit(SigninFailure(message: 'Sign in failed. Please try again.'));
          },
          (signinResponse) {
            emit(SigninSuccess(message: 'successfully signed in '));
          },
        );
      } catch (error) {
        emit(
          SigninFailure(
            message: "An unexpected error occurred: ${error.toString()}",
          ),
        );
      }
    });

    on<TogglePasswordVisibility>((
      TogglePasswordVisibility event,
      Emitter<SigninState> emit,
    ) {
      isPasswordVisible = !isPasswordVisible;
      emit(SigninPasswordVisibilityToggled(isPasswordVisible));
    });
  }
}
