import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

@injectable
class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthRepository authRepository;
  PasswordResetBloc(this.authRepository) : super(PasswordResetInitial()) {
    on<PasswordResetPressed>(_onPasswordResetPressed);
  }

  Future<void> _onPasswordResetPressed(
    PasswordResetPressed event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (event.passwordResetEmail.isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      emit(PasswordResetError(errorMessage: 'Field is empty'));
      await Future.delayed(const Duration(seconds: 2));
      emit(PasswordResetInitial());
    } else {
      emit(PasswordResetLoading());
      await authRepository
          .resetPassword(passwordResetText: event.passwordResetEmail)
          .then((isReset) {
        if (isReset) {
          FocusManager.instance.primaryFocus?.unfocus();
          emit(PasswordResetSuccess());
        }
      }).onError((error, _) async {
        FocusManager.instance.primaryFocus?.unfocus();
        emit(PasswordResetError(
            errorMessage: error.toString().replaceFirst('Exception: ', '')));
        await Future.delayed(const Duration(seconds: 2));
        emit(PasswordResetInitial());
      });
    }
  }
}
