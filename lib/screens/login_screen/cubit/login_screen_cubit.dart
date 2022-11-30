import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit()
      : super(
          LoginScreenState(
            email: '',
            password: '',
            isCreatingAccount: false,
            isLoading: false,
          ),
        );
  Future<void> switchLoginRegister() async {
    emit(
      LoginScreenState(
          email: '',
          password: '',
          isCreatingAccount: !state.isCreatingAccount,
          isLoading: false),
    );
  }

  Future<void> switchLoading() async {
    emit(
      LoginScreenState(
          email: '',
          password: '',
          isCreatingAccount: false,
          isLoading: !state.isLoading),
    );
  }
}
