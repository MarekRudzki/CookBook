// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../features/authentication/data/datasources/local/user_local_data_source.dart'
    as _i8;
import '../features/authentication/data/datasources/remote/auth_firebase_remote_data_source.dart'
    as _i3;
import '../features/authentication/data/datasources/remote/auth_firestore_remote_data_source.dart'
    as _i4;
import '../features/authentication/domain/repositories/auth_repository.dart'
    as _i9;
import '../features/authentication/presentation/blocs/auth/auth_bloc.dart'
    as _i16;
import '../features/authentication/presentation/blocs/change_password/change_password_bloc.dart'
    as _i10;
import '../features/authentication/presentation/blocs/change_username/change_username_bloc.dart'
    as _i17;
import '../features/authentication/presentation/blocs/delete_account/delete_account_bloc.dart'
    as _i18;
import '../features/authentication/presentation/blocs/login/login_bloc.dart'
    as _i11;
import '../features/authentication/presentation/blocs/logout/logout_bloc.dart'
    as _i12;
import '../features/authentication/presentation/blocs/password_reset/password_reset_bloc.dart'
    as _i14;
import '../features/authentication/presentation/blocs/register/register_bloc.dart'
    as _i15;
import '../features/meals/data/datasources/meals_firestore_remote_data_source.dart'
    as _i5;
import '../features/meals/data/datasources/meals_storage_remote_data_source.dart'
    as _i6;
import '../features/meals/domain/repositories/meals_repository.dart' as _i13;
import '../features/meals/presentation/blocs/meals/meals_bloc.dart' as _i19;
import '../features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart'
    as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AuthFirebaseRemoteDataSource>(
        () => _i3.AuthFirebaseRemoteDataSource());
    gh.lazySingleton<_i4.AuthFirestoreRemoteDataSource>(
        () => _i4.AuthFirestoreRemoteDataSource());
    gh.lazySingleton<_i5.MealsFirestoreRemoteDataSource>(
        () => _i5.MealsFirestoreRemoteDataSource());
    gh.lazySingleton<_i6.MealsStorageRemoteDataSource>(
        () => _i6.MealsStorageRemoteDataSource());
    gh.factory<_i7.PhotoPickerBloc>(() => _i7.PhotoPickerBloc());
    gh.lazySingleton<_i8.UserLocalDataSource>(() => _i8.UserLocalDataSource());
    gh.lazySingleton<_i9.AuthRepository>(() => _i9.AuthRepository(
          authFirestore: gh<_i4.AuthFirestoreRemoteDataSource>(),
          authFirebase: gh<_i3.AuthFirebaseRemoteDataSource>(),
          userLocalDataSource: gh<_i8.UserLocalDataSource>(),
        ));
    gh.factory<_i10.ChangePasswordBloc>(
        () => _i10.ChangePasswordBloc(gh<_i9.AuthRepository>()));
    gh.factory<_i11.LoginBloc>(() => _i11.LoginBloc(gh<_i9.AuthRepository>()));
    gh.factory<_i12.LogoutBloc>(
        () => _i12.LogoutBloc(gh<_i9.AuthRepository>()));
    gh.lazySingleton<_i13.MealsRepository>(() => _i13.MealsRepository(
          mealsFirestore: gh<_i5.MealsFirestoreRemoteDataSource>(),
          mealsStorage: gh<_i6.MealsStorageRemoteDataSource>(),
        ));
    gh.factory<_i14.PasswordResetBloc>(
        () => _i14.PasswordResetBloc(gh<_i9.AuthRepository>()));
    gh.factory<_i15.RegisterBloc>(
        () => _i15.RegisterBloc(gh<_i9.AuthRepository>()));
    gh.factory<_i16.AuthBloc>(() => _i16.AuthBloc(gh<_i9.AuthRepository>()));
    gh.factory<_i17.ChangeUsernameBloc>(() => _i17.ChangeUsernameBloc(
          gh<_i9.AuthRepository>(),
          gh<_i13.MealsRepository>(),
        ));
    gh.factory<_i18.DeleteAccountBloc>(() => _i18.DeleteAccountBloc(
          gh<_i9.AuthRepository>(),
          gh<_i13.MealsRepository>(),
        ));
    gh.factory<_i19.MealsBloc>(() => _i19.MealsBloc(
          gh<_i13.MealsRepository>(),
          gh<_i9.AuthRepository>(),
        ));
    return this;
  }
}
