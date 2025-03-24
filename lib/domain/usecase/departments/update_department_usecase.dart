import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/repository/department_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class UpdateDepartmentUsecase {
  final DepartmentRepository _repository;

  UpdateDepartmentUsecase({required DepartmentRepository repository})
    : _repository = repository;

  Future<Either<Failure, DepartmentEntity>> call(
    DepartmentEntity department,
    List<String> users,
  ) {
    return _repository.updateDepartment(department, users);
  }
}
