import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/data/datasource/user_remote_datasource.dart';
import 'package:orgsync/data/models/user_model.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource _datasource;

  UserRepositoryImpl({required UserRemoteDataSource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUser() async {
    try {
      final response = await _datasource.getUsers();
      final entities = response.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao tentar obter os dados dos usuários.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final UserModel response = await _datasource.login(email, password);
      response.toEntity();
      return Right(response.toEntity());
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao tentar logar. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final UserModel response = await _datasource.register(
        name,
        email,
        password,
      );
      response.toEntity();
      return Right(response.toEntity());
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao registrar. Tente novamente mais tarde.',
        ),
      );
    }
  }

  Either<Failure, T> _handleDioError<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorMessage = e.response?.data['message'] ?? 'Erro desconhecido';
    return Left(ServerFailure(msg: errorMessage, statusCode: statusCode));
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final result = await _datasource.getUser();
      UserEntity user = result.toEntity();
      return Right(user);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao registrar. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(
    String id,
    String name,
    String email,
    String? password,
    int? departmentId,
  ) async {
    try {
      final response = await _datasource.updateUser(
        id,
        name,
        email,
        password,
        departmentId,
      );
      return Right(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao registrar. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      final response = _datasource.deleteUser(id);
      return Right(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg: 'Erro desconhecido ao registrar. Tente novamente mais tarde.',
        ),
      );
    }
  }
}
