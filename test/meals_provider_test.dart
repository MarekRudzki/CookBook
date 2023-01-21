// ignore_for_file: prefer_single_quotes, avoid_returning_null_for_void

import 'dart:io';

import 'package:cookbook/src/features/common_widgets/error_handling.dart';
import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:cookbook/src/services/firebase/storage.dart';
import 'package:cookbook/src/domain/models/meal_model.dart';
import 'package:cookbook/src/services/firebase/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MockFirestore extends Mock implements Firestore {}

class MockStorage extends Mock implements Storage {}

class MockAuth extends Mock implements Auth {}

class MockAccount extends Mock implements AccountProvider {}

class MockErrorHandling extends Mock implements ErrorHandling {}

class MockBuildContext extends Mock implements BuildContext {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });

  late MockFirestore mockFirestore;
  late MockStorage mockStorage;
  late MockAuth mockAuth;
  late AccountProvider mockAccount;
  late MockErrorHandling mockErrorHandling;
  late MockBuildContext mockContext;
  late MockHttpClient mockHttpClient;
  late MealsProvider sut;

  setUp(
    () {
      mockFirestore = MockFirestore();
      mockStorage = MockStorage();
      mockAuth = MockAuth();
      mockAccount = MockAccount();
      mockErrorHandling = MockErrorHandling();
      mockContext = MockBuildContext();
      mockHttpClient = MockHttpClient();

      sut = MealsProvider(
        mockFirestore,
        mockAuth,
        mockStorage,
        mockErrorHandling,
      );
    },
  );

  void errorHandlingSpinner() {
    when(() => mockErrorHandling.toggleMealLoadingSpinner(mockContext))
        .thenReturn(null);
  }

  void errorHandlingInfoSnackBar() {
    when(() => mockErrorHandling.showInfoSnackbar(mockContext, ''))
        .thenReturn(null);
  }

  final List<MealModel> dummyMeals = [
    MealModel(
      id: 'testMeal1',
      name: 'testMeal1',
      description: ['testMeal1'],
      ingredients: ['testMeal1'],
      imageUrl: 'firebasestorage_testMeal1',
      mealAuthor: 'mealAuthor1',
      authorId: 'mealAuthorId1',
      isPublic: false,
      complexity: 'easy',
    ),
    MealModel(
      id: 'testMeal2',
      name: 'testMeal2',
      description: ['testMeal2'],
      ingredients: ['testMeal2'],
      imageUrl: 'firebasestorage_testMeal2',
      mealAuthor: 'mealAuthor1',
      authorId: 'mealAuthorId1',
      isPublic: true,
      complexity: 'hard',
    ),
    MealModel(
      id: 'testMeal3',
      name: 'testMeal3',
      description: ['testMeal3'],
      ingredients: ['testMeal3'],
      imageUrl: 'firebasestorage_testMeal3',
      mealAuthor: 'mealAuthor3',
      authorId: 'mealAuthorId3',
      isPublic: true,
      complexity: 'medium',
    ),
  ];

  test(
    "initial values should be correct",
    () async {
      expect(sut.favoritesId, []);
      expect(sut.complexity, Complexity.easy);
      expect(sut.selectedPhotoType, null);
      expect(sut.isPublic, false);
      expect(sut.imageUrl, '');
      expect(sut.imageFile, null);
      expect(sut.deletePrivateRecipes, true);
      expect(sut.deleteAllRecipes, false);
      expect(sut.selectedCategory, CategoryType.allMeals);
      expect(sut.errorMessage, '');
      expect(sut.isLoading, false);
    },
  );

  test(
    'should check if current UID is meal author ID',
    () async {
      const String authorId = 'testId';
      when(() => mockAuth.getUid()).thenReturn(authorId);

      final bool isAuthor = sut.checkIfAuthor(authorId: authorId);

      expect(isAuthor, true);
    },
  );
  group(
    'meals characteristics',
    () {
      test(
        "should set meal category",
        () {
          const CategoryType category = CategoryType.favorites;

          sut.setMealsCategory(category: category);

          expect(sut.selectedCategory, category);
        },
      );
      test(
        "should set meal complexity",
        () {
          const Complexity complexity = Complexity.hard;

          sut.setComplexity(selectedComplexity: complexity);

          expect(sut.complexity, complexity);
        },
      );
      test(
        "should change meal photo type",
        () {
          const PhotoType photoType = PhotoType.url;

          sut.changePhotoType(photoType);

          expect(sut.selectedPhotoType, photoType);
        },
      );
      test(
        "should remove meal photo",
        () {
          sut.removeCurrentPhoto();

          expect(sut.selectedPhotoType, null);
        },
      );
      test(
        "should set meal public attribute",
        () {
          const bool isPublic = true;

          sut.setPublic(switchPublic: isPublic);

          expect(sut.isPublic, isPublic);
        },
      );
      test(
        "should set meal image",
        () {
          final File image = File('testFile');

          sut.setImage(image: image);

          expect(sut.imageFile, image);
        },
      );
      test(
        "should reset photoType, complexity and isPublic fields",
        () {
          sut.resetFields();

          expect(sut.selectedPhotoType, null);
          expect(sut.complexity, Complexity.easy);
          expect(sut.isPublic, false);
        },
      );
    },
  );

  group(
    'get meals by categories',
    () {
      test(
        "should return user meals",
        () async {
          when(() => mockFirestore.getMeals())
              .thenAnswer((_) async => dummyMeals);
          when(() => mockFirestore.getUserMealsId())
              .thenAnswer((_) async => ['testMeal1', 'testMeal2']);

          final List<MealModel> userMeals = await sut.getUserMeals();

          expect(userMeals.length, 2);
        },
      );
      test(
        "should return public meals",
        () async {
          when(() => mockFirestore.getMeals())
              .thenAnswer((_) async => dummyMeals);

          final List<MealModel> publicMeals = await sut.getPublicMeals();

          expect(publicMeals.length, 2);
        },
      );
      test(
        "should return user favorite meals",
        () async {
          when(() => mockFirestore.getMeals())
              .thenAnswer((_) async => dummyMeals);
          when(() => mockFirestore.getUserFavoriteMealsId())
              .thenAnswer((_) async => ['testMeal1']);

          final List<MealModel> favoriteMeals = await sut.getUserFavorites();

          expect(favoriteMeals.length, 1);
        },
      );
    },
  );
  group(
    'user favorites',
    () {
      test(
        "should toggle favorite single meal",
        () async {
          when(() => mockFirestore.toggleMealFavorite('test'))
              .thenAnswer((_) async => null);
          when(() => mockFirestore.getUserFavoriteMealsId())
              .thenAnswer((_) async => ['testMeal1', 'testMeal2']);

          await sut.toggleMealFavorite(mealId: 'test');

          expect(sut.favoritesId, ['testMeal1', 'testMeal2']);
        },
      );
      test(
        "should fetch user favorite meals id",
        () async {
          when(() => mockFirestore.getUserFavoriteMealsId())
              .thenAnswer((_) async => ['testMeal2']);

          await sut.getFavoritesMealsId();

          expect(sut.favoritesId, ['testMeal2']);
        },
      );
    },
  );
  group(
    'error handling',
    () {
      test(
        "should toggle loading status",
        () {
          final bool currentStatus = sut.isLoading;

          sut.toggleLoading();

          expect(sut.isLoading, !currentStatus);
        },
      );
      test(
        "should add error message",
        () {
          const String message = 'errorMessage';

          sut.addErrorMessage(message: message);

          expect(sut.errorMessage, message);
        },
      );
      test(
        "should reset error message",
        () async {
          sut.errorMessage = 'error';

          await sut.resetErrorMessage();

          expect(sut.errorMessage, '');
        },
      );
      test(
        "should validate given url status and type",
        () async {
          const String test =
              'https://philadelphia.aiga.org/wp-content/uploads/2014/04/Test654x234.png';
          final url = Uri.parse(test);

          when(() => mockHttpClient.get(url))
              .thenAnswer((_) async => http.Response('', 200));

          final result = await sut.validateStatusAndType(
            urlAdress: test,
          );

          expect(result, true);
        },
      );
      test(
        "should validate given url",
        () async {
          const String test =
              'https://philadelphia.aiga.org/wp-content/uploads/2014/04/Test654x234.png';

          errorHandlingSpinner();

          await sut.validateUrl(
            context: mockContext,
            urlController: TextEditingController(text: test),
            onSuccess: () {},
          );

          expect(sut.imageUrl, test);
          expect(sut.selectedPhotoType, PhotoType.url);
        },
      );
    },
  );
  group(
    'meal delete',
    () {
      test(
        "should set deleteAllRecipes to true and deletePrivateRecipes to false",
        () {
          sut.setDeleteAll(value: true);

          expect(sut.deleteAllRecipes, true);
          expect(sut.deletePrivateRecipes, false);
        },
      );
      test(
        "should set deletePrivateRecipes to true and deleteAllRecipes to false",
        () {
          sut.setDeletePrivate(value: true);

          expect(sut.deletePrivateRecipes, true);
          expect(sut.deleteAllRecipes, false);
        },
      );
      test(
        "should delete all recipes",
        () async {
          when(() => mockStorage.deleteImage(imageId: any(named: 'imageId')))
              .thenAnswer((_) async => null);
          when(() => mockFirestore.deleteMeal(
                mealId: any(named: 'mealId'),
                userId: any(named: 'userId'),
              )).thenAnswer((_) async => null);

          await sut.deleteMeals(deleteAll: true, userMeals: dummyMeals);

          verify(() => mockFirestore.deleteMeal(
                mealId: any(named: 'mealId'),
                userId: any(named: 'userId'),
              )).called(dummyMeals.length);
          verify(() => mockStorage.deleteImage(imageId: any(named: 'imageId')))
              .called(3);
        },
      );
      test(
        "should delete private recipes",
        () async {
          when(() => mockStorage.deleteImage(imageId: any(named: 'imageId')))
              .thenAnswer((_) async => null);
          when(() => mockFirestore.deleteMeal(
                mealId: any(named: 'mealId'),
                userId: any(named: 'userId'),
              )).thenAnswer((_) async => null);

          await sut.deleteMeals(deleteAll: false, userMeals: dummyMeals);

          verify(() => mockFirestore.deleteMeal(
                mealId: any(named: 'mealId'),
                userId: any(named: 'userId'),
              )).called(1);
          verify(() => mockStorage.deleteImage(imageId: any(named: 'imageId')))
              .called(1);
        },
      );
      test(
        "should delete single meal",
        () async {
          const String mealId = 'testMeal';
          const String authorId = 'testAuthor';
          const String mealImageUrl = 'firebasestorage_test';
          errorHandlingSpinner();
          errorHandlingInfoSnackBar();

          when(() => mockFirestore.deleteMeal(mealId: mealId, userId: authorId))
              .thenAnswer((_) async => null);
          when(() => mockStorage.deleteImage(imageId: mealId))
              .thenAnswer((_) async => null);

          await sut.deleteSingleMeal(
            context: mockContext,
            mealId: mealId,
            authorId: authorId,
            mealImageUrl: mealImageUrl,
            onSuccess: () {},
            mounted: true,
          );

          expect(sut.imageUrl, '');
          verify(() => mockStorage.deleteImage(imageId: mealId)).called(1);
          verify(() => mockErrorHandling.toggleMealLoadingSpinner(mockContext))
              .called(2);
        },
      );
    },
  );
  group(
    'save and update meal',
    () {
      test(
        "save meal",
        () async {
          final TextEditingController mealNameTec =
              TextEditingController(text: 'testMeal');
          final TextEditingController ingredientsTec =
              TextEditingController(text: 'testIngredients');
          final TextEditingController descriptionTec =
              TextEditingController(text: 'testDescription');
          final TextEditingController imageUrlTec =
              TextEditingController(text: 'testUrl');

          errorHandlingSpinner();
          errorHandlingInfoSnackBar();
          when(() => mockStorage.uploadImage(
                mealId: any(named: 'mealId'),
                image: any(named: 'image'),
                selectedPhotoType: any(named: 'selectedPhotoType'),
              )).thenAnswer((_) async => '');
          when(() => mockAccount.getUsername())
              .thenAnswer((_) async => 'mealAuthor');
          when(() => mockStorage.getUrl(mealId: any(named: 'mealId')))
              .thenAnswer((_) async => '');
          when(() => mockAuth.getUid()).thenReturn('testUid');
          when(() => mockFirestore.addMeal(
                mealId: any(named: 'mealId'),
                mealName: mealNameTec.text,
                ingredientsList: any(named: 'ingredientsList'),
                descriptionList: any(named: 'descriptionList'),
                complexity: any(named: 'complexity'),
                isPublic: any(named: 'isPublic'),
                authorId: any(named: 'authorId'),
                authorName: any(named: 'authorName'),
                imageUrl: any(named: 'imageUrl'),
                generatedUid: any(named: 'generatedUid'),
              )).thenAnswer((_) async => '');
          when(() => mockFirestore.getMeals())
              .thenAnswer((_) async => dummyMeals);
          when(() => mockFirestore.getUserMealsId())
              .thenAnswer((_) async => ['testMeal1', 'testMeal2']);

          await sut.saveMeal(
            context: mockContext,
            mealNameTec: mealNameTec,
            ingredientsTec: ingredientsTec,
            descriptionTec: descriptionTec,
            imageUrlTec: imageUrlTec,
            accountProvider: mockAccount,
            mounted: true,
          );
        },
      );
      test(
        "update meal",
        () async {
          final TextEditingController mealNameTec =
              TextEditingController(text: 'testMeal');
          final TextEditingController ingredientsTec =
              TextEditingController(text: 'testIngredients');
          final TextEditingController descriptionTec =
              TextEditingController(text: 'testDescription');
          final TextEditingController imageUrlTec =
              TextEditingController(text: 'testUrl');

          errorHandlingSpinner();
          errorHandlingInfoSnackBar();
          when(() => mockStorage.updateImage(
                mealId: any(named: 'mealId'),
                image: any(named: 'image'),
                selectedPhotoType: any(named: 'selectedPhotoType'),
              )).thenAnswer((_) async => '');
          when(() => mockAccount.getUsername())
              .thenAnswer((_) async => 'mealAuthor');
          when(() => mockStorage.getUrl(mealId: any(named: 'mealId')))
              .thenAnswer((_) async => '');
          when(() => mockAuth.getUid()).thenReturn('testUid');
          when(() => mockFirestore.updateMeal(
                mealId: any(named: 'mealId'),
                mealName: mealNameTec.text,
                ingredientsList: any(named: 'ingredientsList'),
                descriptionList: any(named: 'descriptionList'),
                complexity: any(named: 'complexity'),
                isPublic: any(named: 'isPublic'),
                authorId: any(named: 'authorId'),
                authorName: any(named: 'authorName'),
                imageUrl: any(named: 'imageUrl'),
              )).thenAnswer((_) async => '');

          final MealModel updatedMeal = await sut.updateMeal(
            context: mockContext,
            mealNameTec: mealNameTec,
            ingredientsTec: ingredientsTec,
            descriptionTec: descriptionTec,
            imageUrlTec: imageUrlTec,
            accountProvider: mockAccount,
            currentMealId: 'testMealId',
          );

          expect(updatedMeal.name, 'testMeal');
        },
      );
    },
  );
}
