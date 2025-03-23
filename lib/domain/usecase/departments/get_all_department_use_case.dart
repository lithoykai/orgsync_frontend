import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/repository/department_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class GetAllDepartmentUseCase {
  final DepartmentRepository _repository;

  GetAllDepartmentUseCase({required DepartmentRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<DepartmentEntity>>> call() {
    return _repository.getAllDepartment();
  }
}
