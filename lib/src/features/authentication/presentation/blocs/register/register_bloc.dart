import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc(this.authRepository) : super(RegisterInitial()) {
    on<RegisterPressed>(_onRegisterPressed);
  }
  Future<void> _onRegisterPressed(
    RegisterPressed event,
    Emitter<RegisterState> emit,
  ) async {
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmedPassword.isEmpty ||
        event.username.isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      emit(RegisterError(errorMessage: 'Please fill in all fields'));
      await Future.delayed(const Duration(seconds: 2));
      emit(RegisterInitial());
    } else {
      emit(RegisterLoading());
      try {
        await authRepository.register(
            email: event.email,
            password: event.password,
            username: event.username,
            confirmedPassword: event.confirmedPassword);
        await authRepository.addUserFirestore(
          username: event.username,
        );
        await authRepository.setUsername(username: event.username);
        await authRepository.setUserEmail(email: event.email);

        FocusManager.instance.primaryFocus?.unfocus();
        emit(RegisterSuccess());
      } catch (error) {
        FocusManager.instance.primaryFocus?.unfocus();
        emit(RegisterError(
            errorMessage: error.toString().replaceFirst('Exception: ', '')));
        await Future.delayed(const Duration(seconds: 2));
        emit(RegisterInitial());
      }
    }
  }
}
