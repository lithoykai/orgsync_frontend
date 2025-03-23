import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/data/datasource/department_remote_datasource.dart';
import 'package:orgsync/data/datasource/department_remote_datasource_impl.dart';
import 'package:orgsync/data/models/department_model.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/repository/department_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@Injectable(as: DepartmentRepository)
class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDatasource _datasource;

  DepartmentRepositoryImpl({required DepartmentRemoteDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, DepartmentEntity>> addMemberToDepartment(
    int departmentId,
    String userId,
  ) async {
    try {
      final response = await _datasource.addUsersInDepartment(departmentId, [
        userId,
      ]);
      var entity = response.toEntity();
      return Right(entity);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg:
              'Erro desconhecido ao adicionar o colaborador no departamentos. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createDepartment(
    DepartmentEntity department,
    List<String> users,
  ) async {
    try {
      final model = DepartmentModel.fromEntity(department);
      final response = await _datasource.createDepartment(model, users);
      return Right(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg:
              'Erro desconhecido ao criar um departamento. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteDepartment(int departmentID) async {
    try {
      final response = await _datasource.deleteDepartment(departmentID);
      return Right(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg:
              'Erro desconhecido ao tentar deletar um departamento. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getAllDepartment() async {
    try {
      final response = await _datasource.getDepartments();
      List<DepartmentEntity> departments =
          response.map((e) => e.toEntity()).toList();
      return Right(departments);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg:
              'Erro desconhecido ao buscar os departamentos. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> getDepartmentById(int id) async {
    // TODO: implement getDepartmentById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartmentByUserId(
    String userId,
  ) async {
    // TODO: implement getDepartmentByUserId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DepartmentEntity>> removeMemberFromDepartment(
    int departmentId,
    List<String> userId,
  ) async {
    try {
      final response = await _datasource.removeUserInDepartment(
        departmentId,
        userId,
      );
      DepartmentEntity departmentEntity = response.toEntity();
      return Right(departmentEntity);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(
        AppFailure(
          msg:
              'Erro desconhecido ao remover o usuário do departamento. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> updateDepartment(
    DepartmentEntity department,
  ) async {
    // TODO: implement updateDepartment
    throw UnimplementedError();
  }

  Either<Failure, T> _handleDioError<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorMessage = e.response?.data['message'] ?? 'Erro desconhecido';
    return Left(ServerFailure(msg: errorMessage, statusCode: statusCode));
  }
}
