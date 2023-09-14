import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

@injectable
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthRepository authRepository;

  ChangePasswordBloc(this.authRepository) : super(ChangePasswordInitial()) {
    on<ChangePasswordPressed>(_onChangePasswordPressed);
  }

  Future<void> _onChangePasswordPressed(
    ChangePasswordPressed event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (event.currentPassword.trim().isEmpty ||
        event.newPassword.trim().isEmpty ||
        event.confirmedNewPassword.trim().isEmpty) {
      emit(ChangePasswordError(errorMessage: 'Please fill in all fields'));
      await Future.delayed(const Duration(seconds: 2));
      emit(ChangePasswordInitial());
    }

    if (event.newPassword.trim() != event.confirmedNewPassword.trim()) {
      emit(ChangePasswordError(errorMessage: 'Given passwords do not match'));
      await Future.delayed(const Duration(seconds: 2));
      emit(ChangePasswordInitial());
    }

    emit(ChangePasswordLoading());
    try {
      await authRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmedNewPassword: event.confirmedNewPassword,
      );
      FocusManager.instance.primaryFocus?.unfocus();
      emit(ChangePasswordSuccess());
    } catch (error) {
      FocusManager.instance.primaryFocus?.unfocus();
      emit(ChangePasswordError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      await Future.delayed(const Duration(seconds: 2));
      emit(ChangePasswordInitial());
    }
  }
}
