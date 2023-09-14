import 'package:cookbook/src/features/authentication/data/datasources/remote/auth_firebase_remote_data_source.dart';
import 'package:cookbook/src/features/authentication/data/datasources/local/user_local_data_source.dart';
import 'package:cookbook/src/features/authentication/data/datasources/remote/auth_firestore_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final AuthFirebaseRemoteDataSource authFirebase;
  final AuthFirestoreRemoteDataSource authFirestore;
  final UserLocalDataSource userLocalDataSource;

  AuthRepository({
    required this.authFirestore,
    required this.authFirebase,
    required this.userLocalDataSource,
  });

  // Local data source
  bool isUserLogged() {
    return userLocalDataSource.isLogged();
  }

  Future<void> setUserEmail({required String email}) async {
    await userLocalDataSource.setUserEmail(email);
  }

  String getUserEmail() {
    return userLocalDataSource.getUserEmail();
  }

  Future<void> removeUserEmail() async {
    await userLocalDataSource.removeUserEmail();
  }

  Future<void> setUsername({required String username}) async {
    await userLocalDataSource.setUsername(username: username);
  }

  String getUsernameHive() {
    return userLocalDataSource.getUsername();
  }

  Future<void> removeUsername() async {
    await userLocalDataSource.removeUsername();
  }

  // Remote data Source

  String getUid() {
    return authFirebase.getUid();
  }

  String? getEmailFromFirebase() {
    return authFirebase.getEmail();
  }

  Future<String> getUsernameFirestore() async {
    final uid = authFirebase.getUid();
    final username = await authFirestore.getUsername(uid: uid);
    return username;
  }

  Future<void> addUserFirestore({
    List<String> userMealsId = const [],
    required String username,
  }) async {
    final uid = authFirebase.getUid();

    await authFirestore.addUser(
      uid: uid,
      userMealsId: userMealsId,
      username: username,
    );
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await authFirebase.logIn(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String confirmedPassword,
  }) async {
    await authFirebase.register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    );
  }

  Future<bool> resetPassword({
    required String passwordResetText,
  }) async {
    final bool isReset = await authFirebase.resetPassword(
      passwordResetText: passwordResetText,
    );
    return isReset;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmedNewPassword,
  }) async {
    await authFirebase.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmedNewPassword: confirmedNewPassword,
    );
  }

  Future<void> validateUserPassword({required String password}) async {
    await authFirebase.validateUserPassword(
      password: password,
    );
  }

  Future<void> deleteUserFirebase() async {
    await authFirebase.deleteUser();
  }

  Future<void> deleteUserFirestore() async {
    final uid = authFirebase.getUid();
    await authFirestore.deleteUserData(uid: uid);
  }

  Future<void> signOut() async {
    await authFirebase.signOut();
  }
}
