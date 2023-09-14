import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/logout/logout_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late LogoutBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        sut = LogoutBloc(authRepository),
      });

  group('Logout Bloc', () {
    blocTest<LogoutBloc, LogoutState>(
      'emits [LogoutLoading] and [LogoutSuccess] when LogOutPressed is added.',
      build: () {
        when(() => authRepository.signOut()).thenAnswer((_) async {});
        when(() => authRepository.removeUserEmail()).thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) => bloc.add(LogOutPressed()),
      expect: () => [
        LogoutLoading(),
        LogoutSuccess(),
      ],
    );
  });
}
