import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'change_username_event.dart';
part 'change_username_state.dart';

@injectable
class ChangeUsernameBloc
    extends Bloc<ChangeUsernameEvent, ChangeUsernameState> {
  final AuthRepository authRepository;
  final MealsRepository mealsRepository;
  ChangeUsernameBloc(this.authRepository, this.mealsRepository)
      : super(ChangeUsernameInitial()) {
    on<ChangeUsernamePressed>(_onChangeUsernamePressed);
  }

  Future<void> _onChangeUsernamePressed(
    ChangeUsernamePressed event,
    Emitter<ChangeUsernameState> emit,
  ) async {
    if (event.newUsername.isEmpty) {
      emit(ChangeUsernameError(errorMessage: 'Field is empty'));
      await Future.delayed(const Duration(seconds: 2));
      emit(ChangeUsernameInitial());
    } else {
      emit(ChangeUsernameLoading());
      try {
        final String uid = authRepository.getUid();
        final List<String> userMealsId =
            await mealsRepository.getUserMealsId(uid: uid);

        await authRepository.addUserFirestore(
            userMealsId: userMealsId, username: event.newUsername);
        await mealsRepository.updateMealAuthor(
            newUsername: event.newUsername, uid: uid);
        await authRepository.setUsername(username: event.newUsername);

        FocusManager.instance.primaryFocus?.unfocus();
        emit(ChangeUsernameSuccess());
      } catch (error) {
        FocusManager.instance.primaryFocus?.unfocus();
        emit(ChangeUsernameError(
            errorMessage: error.toString().replaceFirst('Exception: ', '')));
        await Future.delayed(const Duration(seconds: 2));
        emit(ChangeUsernameInitial());
      }
    }
  }
}
