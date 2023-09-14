import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_username/change_username_bloc.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockMealsRepository extends Mock implements MealsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late MealsRepository mealsRepository;
  late ChangeUsernameBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        mealsRepository = MockMealsRepository(),
        sut = ChangeUsernameBloc(
          authRepository,
          mealsRepository,
        ),
      });

  group('Change Username Bloc', () {
    blocTest<ChangeUsernameBloc, ChangeUsernameState>(
      'emits [ChangeUsernameError] when ChangeUsernamePressed is added with empty new username.',
      build: () => sut,
      act: (bloc) => bloc.add(ChangeUsernamePressed(newUsername: '')),
      expect: () => [
        ChangeUsernameError(errorMessage: 'Field is empty'),
      ],
    );
    blocTest<ChangeUsernameBloc, ChangeUsernameState>(
      'emits [ChangeUsernameLoading] and [ChangeUsernameSuccess] when ChangeUsernamePressed is added with proper data.',
      build: () {
        when(() => authRepository.getUid()).thenReturn('uid');
        when(() => mealsRepository.getUserMealsId(uid: any(named: 'uid')))
            .thenAnswer((_) async => ['user_meal_1', 'user_meal_2']);
        when(() => authRepository.addUserFirestore(
            username: any(named: 'username'),
            userMealsId: any(named: 'userMealsId'))).thenAnswer((_) async {});
        when(() => mealsRepository.updateMealAuthor(
            newUsername: any(named: 'newUsername'),
            uid: any(named: 'uid'))).thenAnswer((_) async {});
        when(() => authRepository.setUsername(username: any(named: 'username')))
            .thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) =>
          bloc.add(ChangeUsernamePressed(newUsername: 'newUsername')),
      expect: () => [
        ChangeUsernameLoading(),
        ChangeUsernameSuccess(),
      ],
    );
  });
}
