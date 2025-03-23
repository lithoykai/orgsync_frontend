import 'package:dartz/dartz.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/infra/failure/failure.dart';

abstract interface class DepartmentRepository {
  Future<Either<Failure, DepartmentEntity>> createDepartment(
    DepartmentEntity department,
  );
  Future<Either<Failure, DepartmentEntity>> updateDepartment(
    DepartmentEntity department,
  );
  Future<void> deleteDepartment(DepartmentEntity department);
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
