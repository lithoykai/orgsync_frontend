import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class DeleteUserUsecase {
  final UserRepository _userRepository;

  DeleteUserUsecase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<Either<Failure, void>> call(String id) async {
    return await _userRepository.deleteUser(id);
  }
}
