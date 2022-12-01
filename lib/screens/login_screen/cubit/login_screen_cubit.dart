import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit()
      : super(
          LoginScreenState(),
        );
  Future<void> switchLoginRegister() async {
    emit(
      LoginScreenState(
        isCreatingAccount: !state.isCreatingAccount,
      ),
    );
  }

  Future<void> switchLoading() async {
    emit(
      LoginScreenState(
        isLoading: !state.isLoading,
      ),
    );
  }

  Future<void> addErrorMessage(String errorText) async {
    emit(
      LoginScreenState(
        isLoading: state.isLoading,
        errorMessage: errorText,
      ),
    );
  }
}
