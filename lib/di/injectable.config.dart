// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/datasource/client/http_service.dart' as _i791;
import '../data/datasource/client/third_module.dart' as _i812;
import '../data/datasource/department_remote_datasource.dart' as _i650;
import '../data/datasource/department_remote_datasource_impl.dart' as _i200;
import '../data/datasource/user_remote_datasource.dart' as _i498;
import '../data/datasource/user_remote_datasource_impl.dart' as _i32;
import '../data/repositories/department_repository_impl.dart' as _i633;
import '../data/repositories/user_repository_impl.dart' as _i223;
import '../domain/repository/department_repository.dart' as _i205;
import '../domain/repository/user_repository.dart' as _i541;
import '../domain/services/token_provider.dart' as _i346;
import '../domain/usecase/departments/create_department_usecase.dart' as _i275;
import '../domain/usecase/departments/get_all_department_use_case.dart'
    as _i614;
import '../domain/usecase/departments/remove_user_department_usecase.dart'
    as _i648;
import '../domain/usecase/user/authenticate_use_case.dart' as _i128;
import '../domain/usecase/user/delete_user_usecase.dart' as _i820;
import '../domain/usecase/user/get_all_users_use_case.dart' as _i88;
import '../domain/usecase/user/get_current_user_usecase.dart' as _i524;
import '../domain/usecase/user/update_user_usecase.dart' as _i388;
import '../infra/security/secure_token_provider.dart' as _i841;
import '../presentation/screens/auth/controller/auth_controller.dart' as _i529;
import '../presentation/screens/department/controller/department_controller.dart'
    as _i630;
import '../presentation/screens/user/controller/user_controller.dart' as _i298;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i361.Dio>(() => registerModule.dio());
  gh.factory<_i346.TokenProvider>(() => _i841.SecureTokenProvider());
  gh.lazySingleton<_i791.HttpService>(
    () => _i791.HttpService(gh<_i361.Dio>(), gh<_i346.TokenProvider>()),
  );
  gh.factory<_i498.UserRemoteDataSource>(
    () => _i32.UserRemoteDatasourceImpl(
      http: gh<_i791.HttpService>(),
      tokenProvider: gh<_i346.TokenProvider>(),
    ),
  );
  gh.factory<_i650.DepartmentRemoteDatasource>(
    () => _i200.DepartmentRemoteDatasourceImpl(
      httpService: gh<_i791.HttpService>(),
    ),
  );
  gh.factory<_i541.UserRepository>(
    () =>
        _i223.UserRepositoryImpl(datasource: gh<_i498.UserRemoteDataSource>()),
  );
  gh.factory<_i205.DepartmentRepository>(
    () => _i633.DepartmentRepositoryImpl(
      datasource: gh<_i650.DepartmentRemoteDatasource>(),
    ),
  );
  gh.factory<_i614.GetAllDepartmentUseCase>(
    () => _i614.GetAllDepartmentUseCase(
      repository: gh<_i205.DepartmentRepository>(),
    ),
  );
  gh.factory<_i275.CreateDepartmentUsecase>(
    () => _i275.CreateDepartmentUsecase(
      repository: gh<_i205.DepartmentRepository>(),
    ),
  );
  gh.factory<_i648.RemoveUserDepartmentUsecase>(
    () => _i648.RemoveUserDepartmentUsecase(
      repository: gh<_i205.DepartmentRepository>(),
    ),
  );
  gh.factory<_i88.GetAllUsersUseCase>(
    () => _i88.GetAllUsersUseCase(userRepository: gh<_i541.UserRepository>()),
  );
  gh.factory<_i524.GetCurrentUserUsecase>(
    () =>
        _i524.GetCurrentUserUsecase(userRepository: gh<_i541.UserRepository>()),
  );
  gh.factory<_i388.UpdateUserUsecase>(
    () => _i388.UpdateUserUsecase(userRepository: gh<_i541.UserRepository>()),
  );
  gh.factory<_i820.DeleteUserUsecase>(
    () => _i820.DeleteUserUsecase(userRepository: gh<_i541.UserRepository>()),
  );
  gh.lazySingleton<_i630.DepartmentController>(
    () => _i630.DepartmentController(
      getAllUseCase: gh<_i614.GetAllDepartmentUseCase>(),
      createDepartmentUsecase: gh<_i275.CreateDepartmentUsecase>(),
      removeUserDepartmentUsecase: gh<_i648.RemoveUserDepartmentUsecase>(),
    ),
  );
  gh.factory<_i128.AuthenticateUseCase>(
    () => _i128.AuthenticateUseCase(repository: gh<_i541.UserRepository>()),
  );
  gh.singleton<_i529.AuthController>(
    () => _i529.AuthController(
      tokenProvider: gh<_i346.TokenProvider>(),
      authenticateUseCase: gh<_i128.AuthenticateUseCase>(),
      getCurrentUserUsecase: gh<_i524.GetCurrentUserUsecase>(),
    ),
  );
  gh.lazySingleton<_i298.UserController>(
    () => _i298.UserController(
      getAllUseCase: gh<_i88.GetAllUsersUseCase>(),
      updateUser: gh<_i388.UpdateUserUsecase>(),
      deleteUseCase: gh<_i820.DeleteUserUsecase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i812.RegisterModule {}
