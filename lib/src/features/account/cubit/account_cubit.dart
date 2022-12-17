import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit()
      : super(
          AccountState(),
        );
  Future<void> switchLoginRegister() async {
    emit(
      AccountState(
        isCreatingAccount: !state.isCreatingAccount,
      ),
    );
  }

  Future<void> switchLoading() async {
    emit(
      AccountState(
        isLoading: !state.isLoading,
      ),
    );
  }

  Future<void> addErrorMessage(String errorText) async {
    emit(
      AccountState(
        isLoading: state.isLoading,
        errorMessage: errorText,
      ),
    );
  }

  Future<void> clearErrorMessage() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    emit(
      AccountState(),
    );
  }
}
