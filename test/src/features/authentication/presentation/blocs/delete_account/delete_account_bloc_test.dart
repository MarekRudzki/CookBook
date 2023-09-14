import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockMealsRepository extends Mock implements MealsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepository authRepository;
  late MealsRepository mealsRepository;
  late DeleteAccountBloc sut;

  setUp(() => {
        authRepository = MockAuthRepository(),
        mealsRepository = MockMealsRepository(),
        sut = DeleteAccountBloc(
          authRepository,
          mealsRepository,
        ),
      });

  group('Delete Account Bloc', () {
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountLoading] and [DeleteAccountSuccess] when DeleteAccountPressed is added.',
      build: () {
        when(() => mealsRepository.getMeals()).thenAnswer((_) async => [
              MealModel(
                  id: 'id',
                  name: 'name',
                  description: ['description'],
                  ingredients: ['ingredients'],
                  imageUrl: 'imageUrl',
                  mealAuthor: 'mealAuthor',
                  authorId: 'authorId',
                  isPublic: false,
                  complexity: 'Easy')
            ]);
        when(() => authRepository.validateUserPassword(
            password: any(named: 'password'))).thenAnswer((_) async {});
        when(() => authRepository.getUid()).thenReturn('uid');
        when(() => mealsRepository.deleteMeals(
            deleteAll: any(named: 'deleteAll'),
            uid: any(named: 'uid'))).thenAnswer((_) async {});
        when(() => authRepository.removeUserEmail()).thenAnswer((_) async {});
        when(() => authRepository.removeUsername()).thenAnswer((_) async {});
        when(() => authRepository.deleteUserFirestore())
            .thenAnswer((_) async {});
        when(() => authRepository.deleteUserFirebase())
            .thenAnswer((_) async {});
        return sut;
      },
      act: (bloc) => bloc.add(DeleteAccountPressed(
        password: 'password',
        deleteAllRecipes: false,
      )),
      expect: () => [
        DeleteAccountLoading(),
        DeleteAccountSuccess(),
      ],
    );
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountInitial] with true value for userHasMeals bool when UserMealsCheck is added and user has meals.',
      build: () {
        when(() => mealsRepository.getUserMeals(uid: any(named: 'uid')))
            .thenAnswer((_) async => [
                  MealModel(
                      id: 'id',
                      name: 'name',
                      description: ['description'],
                      ingredients: ['ingredients'],
                      imageUrl: 'imageUrl',
                      mealAuthor: 'mealAuthor',
                      authorId: 'authorId',
                      isPublic: false,
                      complexity: 'Easy')
                ]);

        when(() => authRepository.getUid()).thenReturn('uid');
        return sut;
      },
      act: (bloc) => bloc.add(UserMealsCheck()),
      expect: () => [DeleteAccountInitial(userHasMeals: true)],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountInitial] with false value for userHasMeals bool when UserMealsCheck is added and user has no meals.',
      build: () {
        when(() => mealsRepository.getUserMeals(uid: any(named: 'uid')))
            .thenAnswer((_) async => []);

        when(() => authRepository.getUid()).thenReturn('uid');
        return sut;
      },
      act: (bloc) => bloc.add(UserMealsCheck()),
      expect: () => [DeleteAccountInitial()],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountInitial] with deleteAllRecipes:true when DeleteMealsOptionChanged is added and event delivers true.',
      build: () => sut,
      act: (bloc) => bloc.add(DeleteMealsOptionChanged(deleteAllRecipes: true)),
      expect: () => [DeleteAccountInitial(deleteAllRecipes: true)],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountInitial] with deleteAllRecipes:false when DeleteMealsOptionChanged is added and event delivers false.',
      build: () => sut,
      act: (bloc) =>
          bloc.add(DeleteMealsOptionChanged(deleteAllRecipes: false)),
      expect: () => [DeleteAccountInitial()],
    );
  });
}
