import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMealsRepository extends Mock implements MealsRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MealsRepository mealsRepository;
  late AuthRepository authRepository;
  late MealsBloc sut;
  final MealModel firstMeal = MealModel(
    id: 'id',
    name: 'name',
    description: ['description'],
    ingredients: ['ingredients'],
    imageUrl: 'imageUrl',
    mealAuthor: 'mealAuthor',
    authorId: 'authorId',
    isPublic: true,
    complexity: 'complexity',
  );
  final MealModel secondMeal = MealModel(
    id: 'id2',
    name: 'name2',
    description: ['description2'],
    ingredients: ['ingredients2'],
    imageUrl: 'imageUrl2',
    mealAuthor: 'mealAuthor2',
    authorId: 'authorId2',
    isPublic: false,
    complexity: 'complexity2',
  );
  final List<MealModel> allMeals = [firstMeal, secondMeal];

  setUp(() {
    mealsRepository = MockMealsRepository();
    authRepository = MockAuthRepository();
    sut = MealsBloc(mealsRepository, authRepository);

    when(() => authRepository.getUid()).thenReturn('uid');
    when(() => mealsRepository.getMeals()).thenAnswer((_) async => allMeals);
    when(() => mealsRepository.getUserMealsId(uid: 'uid'))
        .thenAnswer((_) async => ['id2']);
    when(() => mealsRepository.getUserFavoriteMealsId(uid: 'uid'))
        .thenAnswer((_) async => ['id1']);
    when(() => mealsRepository.toggleMealFavorite(
        mealId: any(named: 'mealId'), uid: 'uid')).thenAnswer((_) async {});
    when(() => mealsRepository.uploadImage(
        mealId: 'mealId',
        image: File('image'),
        selectedPhotoType: PhotoType.camera)).thenAnswer((_) async {});
    when(() => mealsRepository.getUrl(mealId: 'mealId'))
        .thenAnswer((_) async => 'imageUrl');
    when(() => authRepository.getUsernameHive()).thenReturn('usernameHive');
    when(() => authRepository.getUsernameFirestore())
        .thenAnswer((_) async => 'usernameFirestore');
    when(() => mealsRepository.addMeal(
        mealId: any(named: 'mealId'),
        mealName: any(named: 'mealName'),
        ingredientsList: any(named: 'ingredientsList'),
        descriptionList: any(named: 'descriptionList'),
        complexity: any(named: 'complexity'),
        isPublic: any(named: 'isPublic'),
        authorId: any(named: 'authorId'),
        authorName: any(named: 'authorName'),
        imageUrl: any(named: 'imageUrl'),
        generatedUid: any(named: 'generatedUid'))).thenAnswer((_) async {});
    when(() => mealsRepository.updateMeal(
        mealId: any(named: 'mealId'),
        mealName: any(named: 'mealName'),
        ingredientsList: any(named: 'ingredientsList'),
        descriptionList: any(named: 'descriptionList'),
        complexity: any(named: 'complexity'),
        isPublic: any(named: 'isPublic'),
        authorId: any(named: 'authorId'),
        authorName: any(named: 'authorName'),
        imageUrl: any(named: 'imageUrl'))).thenAnswer((_) async {});
    when(() => mealsRepository.deleteMeal(
        mealId: any(named: 'mealId'),
        userId: any(named: 'userId'),
        imageUrl: any(named: 'imageUrl'))).thenAnswer((_) async {});
  });

  group('Meals Bloc', () {
    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoaded] with userMeals when MealsRequested is added with adequate category type.',
      build: () => sut,
      act: (bloc) => bloc.add(MealsRequested(category: CategoryType.myMeals)),
      expect: () => [
        MealsLoading(),
        MealsLoaded(category: CategoryType.myMeals, data: [secondMeal]),
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoaded] with allMeals when MealsRequested is added with adequate category type.',
      build: () => sut,
      act: (bloc) => bloc.add(MealsRequested(category: CategoryType.allMeals)),
      expect: () => [
        MealsLoading(),
        MealsLoaded(category: CategoryType.allMeals, data: [firstMeal]),
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoaded] with favorites when MealsRequested is added with adequate category type.',
      build: () => sut,
      act: (bloc) => bloc.add(MealsRequested(category: CategoryType.favorites)),
      expect: () => [
        MealsLoading(),
        MealsLoaded(category: CategoryType.favorites, data: [firstMeal]),
      ],
    );

    test('checks if given author id is meal author', () {
      final isAuthor = sut.checkIfAuthor(authorId: 'uid');
      expect(isAuthor, true);

      final isAuthor2 = sut.checkIfAuthor(authorId: 'uid2');
      expect(isAuthor2, false);
    });

    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoading] and [UserFavoriteMealsIdRequested] when UserFavoriteMealsIdRequested is added.',
      build: () => sut,
      act: (bloc) => bloc.add(UserFavoriteMealsIdRequested()),
      expect: () => [
        MealsLoading(),
        UserFavoriteMealsIdLoaded(mealsId: ['id1'])
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsInitial] when MealCharacteristicsChanged is added.',
      build: () => sut,
      act: (bloc) => bloc.add(MealCharacteristicsChanged(
          complexity: Complexity.hard, isPublic: false)),
      expect: () => [MealsInitial(complexity: Complexity.hard)],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MyState] when ResetInitialState is added.',
      build: () => sut,
      act: (bloc) => bloc.add(ResetInitialState()),
      expect: () => [MealsInitial()],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsError] when AddMealPressed is added with empty mealName.',
      build: () => sut,
      act: (bloc) => bloc.add(AddMealPressed(
          mealName: '',
          ingredients: 'ingredients',
          description: 'description',
          imageUrl: 'imageUrl',
          selectedPhotoType: PhotoType.camera,
          complexity: Complexity.medium,
          isPublic: true)),
      expect: () => [
        MealsError(errorMessage: 'Please fill in all fields'),
        MealsInitial(
          complexity: Complexity.medium,
          isPublic: true,
        )
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsError] when AddMealPressed is added with empty ingredients.',
      build: () => sut,
      act: (bloc) => bloc.add(AddMealPressed(
          mealName: 'mealName',
          ingredients: '',
          description: 'description',
          imageUrl: 'imageUrl',
          selectedPhotoType: PhotoType.camera,
          complexity: Complexity.medium,
          isPublic: true)),
      expect: () => [
        MealsError(errorMessage: 'Please fill in all fields'),
        MealsInitial(
          complexity: Complexity.medium,
          isPublic: true,
        )
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsError] when AddMealPressed is added with empty description.',
      build: () => sut,
      act: (bloc) => bloc.add(AddMealPressed(
          mealName: 'mealName',
          ingredients: 'ingredients',
          description: '',
          imageUrl: 'imageUrl',
          selectedPhotoType: PhotoType.camera,
          complexity: Complexity.medium,
          isPublic: true)),
      expect: () => [
        MealsError(errorMessage: 'Please fill in all fields'),
        MealsInitial(
          complexity: Complexity.medium,
          isPublic: true,
        )
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoading] and[MealSaved] and [MealsInitial] when AddMealPressed is added with proper data.',
      build: () => sut,
      act: (bloc) => bloc.add(AddMealPressed(
          mealName: 'mealName',
          ingredients: 'ingredients',
          description: 'description',
          imageUrl: 'imageUrl',
          selectedPhotoType: PhotoType.url,
          complexity: Complexity.medium,
          isPublic: true)),
      expect: () => [
        MealsLoading(),
        MealSaved(),
        MealsInitial(),
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealsLoading] [MealSaved] and [MealsInitial] when EditMealPressed is added.',
      build: () => sut,
      act: (bloc) => bloc.add(EditMealPressed(
          authorId: 'authorId',
          mealAuthor: 'mealAuthor',
          mealId: 'mealId',
          imageFile: File(''),
          mealName: 'mealName',
          ingredients: 'ingredients',
          description: 'description',
          imageUrl: 'imageUrl',
          selectedPhotoType: PhotoType.url,
          complexity: Complexity.medium,
          isPublic: true)),
      expect: () => [
        MealsLoading(),
        MealSaved(),
        MealsInitial(),
      ],
    );

    blocTest<MealsBloc, MealsState>(
      'emits [MealDeleted] and [MealsInitial] when DeleteMealPressed is added.',
      build: () => sut,
      act: (bloc) => bloc.add(DeleteMealPressed(
          mealId: 'mealId', userId: 'userId', imageUrl: 'imageUrl')),
      expect: () => [
        MealDeleted(),
        MealsInitial(),
      ],
    );
  });
}
