part of 'delete_account_bloc.dart';

class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class DeleteAccountPressed extends DeleteAccountEvent {
  final String password;
  final bool deleteAllRecipes;

  DeleteAccountPressed({
    required this.password,
    required this.deleteAllRecipes,
  });

  @override
  List<Object> get props => [
        password,
        deleteAllRecipes,
      ];
}

class UserMealsCheck extends DeleteAccountEvent {}

class DeleteMealsOptionChanged extends DeleteAccountEvent {
  final bool deleteAllRecipes;

  DeleteMealsOptionChanged({required this.deleteAllRecipes});

  @override
  List<Object> get props => [deleteAllRecipes];
}
