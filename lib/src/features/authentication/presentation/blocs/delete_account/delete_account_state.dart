part of 'delete_account_bloc.dart';

class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {
  final bool userHasMeals;
  final bool deleteAllRecipes;

  DeleteAccountInitial({
    this.userHasMeals = false,
    this.deleteAllRecipes = false,
  });

  DeleteAccountInitial copyWith({
    bool? userHasMeals,
    bool? deleteAllRecipes,
  }) {
    return DeleteAccountInitial(
      userHasMeals: userHasMeals ?? this.userHasMeals,
      deleteAllRecipes: deleteAllRecipes ?? this.deleteAllRecipes,
    );
  }

  @override
  List<Object> get props => [deleteAllRecipes];
}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class ExistingMealsChecked extends DeleteAccountState {
  final bool hasMeals;

  ExistingMealsChecked({required this.hasMeals});

  @override
  List<Object> get props => [hasMeals];
}

class DeleteAccountError extends DeleteAccountState {
  final String errorMessage;

  DeleteAccountError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
