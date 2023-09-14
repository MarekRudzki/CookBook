import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/register/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late RegisterBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = RegisterBloc(authRepository),
      });
  group('Register Bloc', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterError] when RegisterPressed is added with empty email.',
      build: () => sut,
      act: (bloc) => bloc.add(RegisterPressed(
          email: '',
          password: 'password',
          username: 'username',
          confirmedPassword: 'confirmedPassword')),
      expect: () => [RegisterError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterError] when RegisterPressed is added with empty password.',
      build: () => sut,
      act: (bloc) => bloc.add(RegisterPressed(
          email: 'email',
          password: '',
          username: 'username',
          confirmedPassword: 'confirmedPassword')),
      expect: () => [RegisterError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterError] when RegisterPressed is added with empty username.',
      build: () => sut,
      act: (bloc) => bloc.add(RegisterPressed(
          email: 'email',
          password: 'password',
          username: '',
          confirmedPassword: 'confirmedPassword')),
      expect: () => [RegisterError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterError] when RegisterPressed is added with empty confirmedPassword.',
      build: () => sut,
      act: (bloc) => bloc.add(RegisterPressed(
          email: 'email',
          password: 'password',
          username: 'username',
          confirmedPassword: '')),
      expect: () => [RegisterError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading] and [RegisterSuccess] when RegisterPressed is added with proper data.',
      build: () {
        when(() => authRepository.register(
                email: any(named: 'email'),
                password: any(named: 'password'),
                username: any(named: 'username'),
                confirmedPassword: any(named: 'confirmedPassword')))
            .thenAnswer((_) async {});
        when(() => authRepository.addUserFirestore(
            username: any(named: 'username'))).thenAnswer((_) async {});
        when(() => authRepository.setUsername(username: any(named: 'username')))
            .thenAnswer((_) async {});
        when(() => authRepository.setUserEmail(email: any(named: 'email')))
            .thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) => bloc.add(RegisterPressed(
          email: 'email@email.com',
          password: 'password',
          username: 'username',
          confirmedPassword: 'password')),
      expect: () => [
        RegisterLoading(),
        RegisterSuccess(),
      ],
    );
  });
}
