import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LogInPressed>(_onLogInPressed);
  }

  Future<void> _onLogInPressed(
    LogInPressed event,
    Emitter<LoginState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      emit(LoginError(errorMessage: 'Please fill in all fields'));
      await Future.delayed(const Duration(seconds: 2));
      emit(LoginInitial());
    } else {
      emit(LoginLoading());
      try {
        await authRepository.logIn(
            email: event.email, password: event.password);
        await authRepository.setUserEmail(email: event.email);

        FocusManager.instance.primaryFocus?.unfocus();
        emit(LoginSuccess());
      } catch (error) {
        FocusManager.instance.primaryFocus?.unfocus();
        emit(LoginError(
            errorMessage: error.toString().replaceFirst('Exception: ', '')));
        await Future.delayed(const Duration(seconds: 2));
        emit(LoginInitial());
      }
    }
  }
}
