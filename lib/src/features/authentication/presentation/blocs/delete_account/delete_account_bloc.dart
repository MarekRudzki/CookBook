import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

@injectable
class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final AuthRepository authRepository;
  final MealsRepository mealsRepository;

  DeleteAccountBloc(this.authRepository, this.mealsRepository)
      : super(DeleteAccountInitial()) {
    on<DeleteAccountPressed>(_onDeleteAccountPressed);
    on<UserMealsCheck>(_onUserMealsCheck);
    on<DeleteMealsOptionChanged>(_onDeleteMealsOptionChanged);
  }

  Future<void> _onDeleteAccountPressed(
    DeleteAccountPressed event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());
    List<MealModel> userMeals = [];
    try {
      userMeals = await mealsRepository.getMeals();
      await authRepository.validateUserPassword(password: event.password);
      if (userMeals.isNotEmpty) {
        await mealsRepository.deleteMeals(
            deleteAll: event.deleteAllRecipes, uid: authRepository.getUid());
      }

      await authRepository.removeUserEmail();
      await authRepository.removeUsername();
      await authRepository.deleteUserFirestore();
      await authRepository.deleteUserFirebase();
      emit(DeleteAccountSuccess());
    } catch (error) {
      emit(DeleteAccountError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      await Future.delayed(const Duration(seconds: 2));
      if (userMeals.isEmpty) {
        emit(DeleteAccountInitial().copyWith(userHasMeals: false));
      } else {
        emit(DeleteAccountInitial().copyWith(userHasMeals: true));
      }
    }
  }

  Future<void> _onUserMealsCheck(
    UserMealsCheck event,
    Emitter<DeleteAccountState> emit,
  ) async {
    final List<MealModel> userMeals =
        await mealsRepository.getUserMeals(uid: authRepository.getUid());
    if (userMeals.isEmpty) {
      emit(DeleteAccountInitial().copyWith(userHasMeals: false));
    } else {
      emit(DeleteAccountInitial().copyWith(userHasMeals: true));
    }
  }

  void _onDeleteMealsOptionChanged(
    DeleteMealsOptionChanged event,
    Emitter<DeleteAccountState> emit,
  ) {
    emit(DeleteAccountInitial().copyWith(
        deleteAllRecipes: event.deleteAllRecipes, userHasMeals: true));
  }
}
