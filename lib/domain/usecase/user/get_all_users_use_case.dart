import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class GetAllUsersUseCase {
  final UserRepository _userRepository;

  GetAllUsersUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<Either<Failure, List<UserEntity>>> call() async {
    return await _userRepository.getAllUser();
  }
}
