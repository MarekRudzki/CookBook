import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'logout_event.dart';
part 'logout_state.dart';

@injectable
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository authRepository;

  LogoutBloc(this.authRepository) : super(LogoutInitial()) {
    on<LogOutPressed>(_onLogOutPressed);
  }

  Future<void> _onLogOutPressed(
    LogOutPressed event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      await authRepository.signOut();
      await authRepository.removeUserEmail();
      emit(LogoutSuccess());
    } catch (error) {
      emit(LogoutError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      await Future.delayed(const Duration(seconds: 2));
      emit(LogoutInitial());
    }
  }
}
