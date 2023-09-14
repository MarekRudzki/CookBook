import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRegisterSwitched>(_onLoginRegisterSwitched);
    on<UsernameRequested>(_onUsernameRequested);
  }

  bool isUserLogged() {
    final bool isLogged = authRepository.isUserLogged();
    return isLogged;
  }

  void _onLoginRegisterSwitched(
    LoginRegisterSwitched event,
    Emitter<AuthState> emit,
  ) {
    emit(LoginRegisterMode(isLoginMode: event.isLoginMode));
  }

  String getEmail() {
    return authRepository.getUserEmail();
  }

  Future<void> _onUsernameRequested(
    UsernameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final String username = authRepository.getUsernameHive();
    if (username == 'no-username') {
      final String firestoreUsername =
          await authRepository.getUsernameFirestore();
      emit(UsernameLoaded(username: firestoreUsername));
    } else {
      emit(UsernameLoaded(username: username));
    }
  }
}
