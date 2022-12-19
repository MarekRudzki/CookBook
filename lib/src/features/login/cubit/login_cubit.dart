import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : super(
          LoginState(),
        );
  Future<void> switchLoginRegister() async {
    emit(
      LoginState(
        isCreatingAccount: !state.isCreatingAccount,
      ),
    );
  }

  Future<void> switchLoading() async {
    emit(
      LoginState(
        isLoading: !state.isLoading,
        isCreatingAccount: state.isCreatingAccount,
      ),
    );
  }

  Future<void> addErrorMessage(String errorText) async {
    emit(
      LoginState(
        isLoading: state.isLoading,
        errorMessage: errorText,
      ),
    );
  }

  Future<void> clearErrorMessage() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
}
