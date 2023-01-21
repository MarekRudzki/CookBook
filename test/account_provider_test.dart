// ignore_for_file: prefer_single_quotes, avoid_returning_null_for_void

import 'package:cookbook/src/features/common_widgets/error_handling.dart';
import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:cookbook/src/services/firebase/auth.dart';
import 'package:cookbook/src/services/hive_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

class MockFirestore extends Mock implements Firestore {}

class MockAuth extends Mock implements Auth {}

class MockHive extends Mock implements HiveServices {}

class MockMeals extends Mock implements MealsProvider {}

class MockErrorHandling extends Mock implements ErrorHandling {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirestore mockFirestore;
  late MockAuth mockAuth;
  late MockHive mockHive;
  late MockMeals mockMeals;
  late ErrorHandling mockErrorHandling;
  late MockBuildContext mockContext;
  late AccountProvider sut;

  setUp(() {
    mockFirestore = MockFirestore();
    mockAuth = MockAuth();
    mockHive = MockHive();
    mockMeals = MockMeals();
    mockErrorHandling = MockErrorHandling();
    mockContext = MockBuildContext();

    sut = AccountProvider(
      mockFirestore,
      mockHive,
      mockAuth,
      mockErrorHandling,
    );
  });

  void errorHandlingSpinner() {
    when(() => mockErrorHandling.toggleAccountLoadingSpinner(mockContext))
        .thenReturn(null);
  }

  void errorHandlingInfoSnackBar() {
    when(() => mockErrorHandling.showInfoSnackbar(mockContext, ''))
        .thenReturn(null);
  }

  test(
    "initial values should be correct",
    () {
      expect(sut.email, '');
      expect(sut.username, '');
      expect(sut.errorMessage, '');
      expect(sut.isCreatingAccount, false);
      expect(sut.isLoading, false);
    },
  );

  group(
    "email and username",
    () {
      test(
        "should fetch user email",
        () {
          when(() => mockHive.getUserEmail()).thenAnswer((_) => 'testEmail');

          final String email = sut.getEmail();

          expect(email, 'testEmail');
        },
      );
      test(
        "should set user email",
        () async {
          const String email = 'testEmail';
          when(() => mockFirestore.getUsername())
              .thenAnswer((_) async => email);

          await sut.setUsername();

          expect(sut.username, email);
        },
      );
      test(
        "should fetch username from database when username is not saved locally",
        () async {
          const String username = 'testUsername';
          when(() => mockHive.getUsername()).thenReturn('no-username');
          when(() => mockFirestore.getUsername())
              .thenAnswer((_) async => username);

          await sut.getUsername();

          expect(sut.username, username);
        },
      );
      test(
        "should fetch username locally",
        () async {
          const String username = 'testUsername';
          when(() => mockHive.getUsername()).thenReturn(username);

          final String returnedUsername = await sut.getUsername();

          expect(returnedUsername, username);
        },
      );
      test(
        "should change username",
        () async {
          const String newUsername = 'newUsername';
          errorHandlingSpinner();
          errorHandlingInfoSnackBar();
          when(() => mockFirestore.addUser(newUsername))
              .thenAnswer((_) async => '');
          when(() => mockFirestore.updateMealAuthor(newUsername: newUsername))
              .thenAnswer((_) async => null);
          when(() => mockHive.setUsername(username: newUsername))
              .thenReturn(null);

          await sut.changeUsername(
            context: mockContext,
            changeUsernameController: TextEditingController(text: newUsername),
            onSuccess: () {},
          );

          expect(sut.username, newUsername);
        },
      );
    },
  );
  group(
    'password',
    () {
      test(
        "should change password",
        () async {
          const String currentPassword = 'currentPassword';
          const String newPassword = 'newPassword';
          errorHandlingSpinner();
          errorHandlingInfoSnackBar();
          when(() => mockAuth.changePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
              confirmedNewPassword: newPassword)).thenAnswer((_) async => '');

          await sut.changePassword(
            context: mockContext,
            currentPasswordController:
                TextEditingController(text: currentPassword),
            newPasswordController: TextEditingController(text: newPassword),
            confirmedNewPasswordController:
                TextEditingController(text: newPassword),
            onSuccess: () {},
          );

          verify(() => mockErrorHandling.showInfoSnackbar(
                  mockContext, 'Password changed successfully', Colors.green))
              .called(1);
        },
      );
      test(
        "should reset password",
        () async {
          const String resetPassword = 'reserPassword';
          errorHandlingSpinner();
          when(() => mockAuth.resetPassword(passwordResetText: resetPassword))
              .thenAnswer((_) async => '');

          await sut.resetPassword(
            context: mockContext,
            passwordResetText: resetPassword,
            onSuccess: () {},
          );

          verify(() =>
                  mockErrorHandling.toggleAccountLoadingSpinner(mockContext))
              .called(2);
        },
      );
    },
  );
  group(
    'Log in and register',
    () {
      test(
        "should switch creating account status",
        () {
          final status = sut.isCreatingAccount;

          sut.switchLoginRegister();

          expect(sut.isCreatingAccount, !status);
        },
      );
      test(
        "should log user in",
        () async {
          const email = 'testEmail';
          const password = 'testPassword';
          errorHandlingSpinner();
          when(() => mockAuth.logIn(email: email, password: password))
              .thenAnswer((_) async => '');
          when(() => mockHive.setUserEmail(email)).thenReturn(null);

          await sut.logIn(
            context: mockContext,
            email: email,
            password: password,
            onSuccess: () {},
          );

          verifyNever(
              () => mockErrorHandling.showInfoSnackbar(mockContext, any()));
        },
      );
      test(
        "should register user",
        () async {
          const email = 'testEmail';
          const password = 'testPassword';
          const username = 'testUsername';
          const confirmedPassword = 'testConfirmedPassword';
          errorHandlingSpinner();
          when(() => mockAuth.register(
                  email: email,
                  password: password,
                  username: username,
                  confirmedPassword: confirmedPassword))
              .thenAnswer((_) async => '');
          when(() => mockFirestore.addUser(username))
              .thenAnswer((_) async => '');
          when(() => mockHive.setUserEmail(email)).thenReturn(null);
          when(() => mockHive.setUsername(username: username)).thenReturn(null);

          await sut.register(
            context: mockContext,
            email: email,
            password: password,
            username: username,
            confirmedPassword: confirmedPassword,
            onSuccess: () {},
          );

          verifyNever(
              () => mockErrorHandling.showInfoSnackbar(mockContext, any()));
        },
      );
    },
  );
  group(
    'Delete and log out',
    () {
      test(
        "should delete user account",
        () async {
          const String password = 'test';
          errorHandlingSpinner();
          errorHandlingInfoSnackBar();
          when(() => mockAuth.getUid()).thenReturn(password);
          when(() => mockMeals.getUserMeals()).thenAnswer((_) async => []);
          when(() => mockAuth.validateUserPassword(password: password))
              .thenAnswer((_) async => '');
          when(() => mockAuth.deleteUser()).thenAnswer((_) async => null);
          when(() => mockHive.removeUserEmail()).thenReturn(null);
          when(() => mockHive.removeUsername()).thenReturn(null);
          when(() => mockFirestore.deleteUserData(password))
              .thenAnswer((_) async => '');

          await sut.deleteAccount(
            context: mockContext,
            currentPasswordController: TextEditingController(text: password),
            mounted: true,
            mealsProvider: mockMeals,
            onSuccess: () {},
          );

          expect(sut.isCreatingAccount, false);
        },
      );
      test(
        "should log out user",
        () async {
          errorHandlingSpinner();
          when(() => mockAuth.signOut()).thenAnswer((_) async => '');
          when(() => mockHive.removeUserEmail()).thenReturn(null);

          sut.logOut(context: mockContext, onSuccess: () {});

          expect(sut.isCreatingAccount, false);
        },
      );
    },
  );
  group(
    'Error handling',
    () {
      test(
        "should change loading status",
        () {
          final currentStatus = sut.isLoading;

          sut.toggleLoading();

          expect(sut.isLoading, !currentStatus);
        },
      );
      test(
        "should add error message",
        () {
          const String errorMessage = 'error';

          sut.addErrorMessage(message: errorMessage);

          expect(sut.errorMessage, errorMessage);
        },
      );
      test(
        "should reset error message after 3 second",
        () async {
          sut.errorMessage = 'error';

          await sut.resetErrorMessage();

          expect(sut.errorMessage, '');
        },
      );
    },
  );
}
