import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/repository/department_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class DeleteDepartmentUsecase {
  final DepartmentRepository _repository;

  DeleteDepartmentUsecase({required DepartmentRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(int id) {
    return _repository.deleteDepartment(id);
  }
}
