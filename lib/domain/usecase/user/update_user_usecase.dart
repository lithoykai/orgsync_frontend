import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class UpdateUserUsecase {
  final UserRepository _userRepository;

  UpdateUserUsecase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<Either<Failure, void>> call(
    String id,
    String name,
    String email,
    String? password,
    int? departmentID,
  ) async {
    return _userRepository.updateUser(id, name, email, password, departmentID);
  }
}
