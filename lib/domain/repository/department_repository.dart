import 'package:dartz/dartz.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/infra/failure/failure.dart';

abstract interface class DepartmentRepository {
  Future<Either<Failure, void>> createDepartment(
    DepartmentEntity department,
    List<String> users,
  );
  Future<Either<Failure, DepartmentEntity>> updateDepartment(
    DepartmentEntity department,
    List<String> users,
  );
  Future<Either<Failure, void>> deleteDepartment(int departmentID);
  Future<Either<Failure, List<DepartmentEntity>>> getAllDepartment();
  Future<Either<Failure, DepartmentEntity>> getDepartmentById(int id);
  Future<Either<Failure, List<DepartmentEntity>>> getDepartmentByUserId(
    String userId,
  );
  Future<Either<Failure, DepartmentEntity>> addMemberToDepartment(
    int departmentId,
    String userId,
  );
  Future<Either<Failure, DepartmentEntity>> removeMemberFromDepartment(
    int departmentId,
    List<String> userId,
  );
}
