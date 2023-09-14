import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late AuthBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = AuthBloc(authRepository),
      });

  group('Auth Bloc', () {
    test('returns if user is logged in', () {
      when(() => authRepository.isUserLogged()).thenAnswer((_) => false);
      final bool isLogged = sut.isUserLogged();
      expect(isLogged, false);

      when(() => authRepository.isUserLogged()).thenAnswer((_) => true);
      final bool isLogged2 = sut.isUserLogged();
      expect(isLogged2, true);
    });

    test('returns user email', () {
      when(() => authRepository.getUserEmail()).thenReturn('email');
      final String userEmail = sut.getEmail();
      expect('email', userEmail);
    });

    blocTest<AuthBloc, AuthState>(
      'emits [LoginRegisterMode] with (isLoginMode:true) when LoginRegisterSwitched is added with true event value.',
      build: () => sut,
      act: (bloc) => bloc.add(LoginRegisterSwitched(isLoginMode: true)),
      expect: () => [
        LoginRegisterMode(isLoginMode: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [LoginRegisterMode] with (isLoginMode:false) when LoginRegisterSwitched is added with false event value.',
      build: () => sut,
      act: (bloc) => bloc.add(LoginRegisterSwitched(isLoginMode: false)),
      expect: () => [
        LoginRegisterMode(isLoginMode: false),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading] and [UsernameLoaded] when UsernameRequested is added and local username (Hive) is not saved.',
      build: () {
        when(() => authRepository.getUsernameHive()).thenReturn('no-username');
        when(() => authRepository.getUsernameFirestore())
            .thenAnswer((_) async => 'usernameFirestore');
        return sut;
      },
      act: (bloc) => bloc.add(UsernameRequested()),
      expect: () => [
        AuthLoading(),
        UsernameLoaded(username: 'usernameFirestore'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading] and [UsernameLoaded] when UsernameRequested is added and local username (Hive) is saved.',
      build: () {
        when(() => authRepository.getUsernameHive()).thenReturn('usernameHive');

        return sut;
      },
      act: (bloc) => bloc.add(UsernameRequested()),
      expect: () => [
        AuthLoading(),
        UsernameLoaded(username: 'usernameHive'),
      ],
    );
  });
}
