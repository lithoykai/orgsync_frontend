import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/repository/department_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class CreateDepartmentUsecase {
  final DepartmentRepository _repository;

  CreateDepartmentUsecase({required DepartmentRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(
    DepartmentEntity entity,
    List<String> users,
  ) {
    return _repository.createDepartment(entity, users);
  }
}
