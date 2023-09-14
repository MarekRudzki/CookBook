import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_password/change_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late ChangePasswordBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = ChangePasswordBloc(authRepository),
      });

  group('Change Password Bloc', () {
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordError] when ChangePasswordPressed is added with empty currentPassword.',
      build: () => sut,
      act: (bloc) => bloc.add(ChangePasswordPressed(
          currentPassword: '',
          newPassword: 'newPassword',
          confirmedNewPassword: 'newPassword')),
      expect: () =>
          [ChangePasswordError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordError] when ChangePasswordPressed is added with empty newPassword.',
      build: () => sut,
      act: (bloc) => bloc.add(ChangePasswordPressed(
          currentPassword: 'currentPassword',
          newPassword: '',
          confirmedNewPassword: 'newPassword')),
      expect: () =>
          [ChangePasswordError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordError] when ChangePasswordPressed is added with empty confirmedNewPassword.',
      build: () => sut,
      act: (bloc) => bloc.add(ChangePasswordPressed(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
          confirmedNewPassword: '')),
      expect: () =>
          [ChangePasswordError(errorMessage: 'Please fill in all fields')],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordError] when ChangePasswordPressed is added and given password do not match.',
      build: () => sut,
      act: (bloc) => bloc.add(ChangePasswordPressed(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
          confirmedNewPassword: 'confirmedNewPassword')),
      expect: () =>
          [ChangePasswordError(errorMessage: 'Given passwords do not match')],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(() => authRepository.changePassword(
                currentPassword: any(named: 'currentPassword'),
                newPassword: any(named: 'newPassword'),
                confirmedNewPassword: any(named: 'confirmedNewPassword')))
            .thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) => bloc.add(ChangePasswordPressed(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
          confirmedNewPassword: 'newPassword')),
      expect: () => [
        ChangePasswordLoading(),
        ChangePasswordSuccess(),
      ],
    );
  });
}
