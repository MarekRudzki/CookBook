import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late LoginBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = LoginBloc(authRepository),
      });

  group('Login Bloc', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginError] when LogInPressed is added with empty email.',
      build: () => sut,
      act: (bloc) => bloc.add(LogInPressed(email: '', password: 'password')),
      expect: () => [LoginError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginError] when LogInPressed is added with empty password.',
      build: () => sut,
      act: (bloc) => bloc.add(LogInPressed(email: 'email', password: '')),
      expect: () => [LoginError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading] and [LoginSuccess] when LogInPressed is added with proper data.',
      build: () {
        when(() => authRepository.logIn(
            email: any(named: 'email'),
            password: any(named: 'password'))).thenAnswer((_) async {});
        when(() => authRepository.setUserEmail(email: any(named: 'email')))
            .thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) =>
          bloc.add(LogInPressed(email: 'email', password: 'password')),
      expect: () => [
        LoginLoading(),
        LoginSuccess(),
      ],
    );
  });
}
