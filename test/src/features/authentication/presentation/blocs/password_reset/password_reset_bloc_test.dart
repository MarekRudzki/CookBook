import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late PasswordResetBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = PasswordResetBloc(authRepository),
      });

  group('Password Reset Bloc', () {
    blocTest<PasswordResetBloc, PasswordResetState>(
      'emits [PasswordResetError] when PasswordResetPressed is added with empty email.',
      build: () => sut,
      act: (bloc) => bloc.add(PasswordResetPressed(passwordResetEmail: '')),
      expect: () => [PasswordResetError(errorMessage: 'Field is empty')],
    );

    blocTest<PasswordResetBloc, PasswordResetState>(
      'emits [PasswordResetLoading] and [PasswordResetSuccess] when PasswordResetPressed is added with proper email.',
      build: () {
        when(() => authRepository.resetPassword(
                passwordResetText: any(named: 'passwordResetText')))
            .thenAnswer((_) async => true);
        return sut;
      },
      act: (bloc) =>
          bloc.add(PasswordResetPressed(passwordResetEmail: 'email')),
      expect: () => [
        PasswordResetLoading(),
        PasswordResetSuccess(),
      ],
    );
  });
}
