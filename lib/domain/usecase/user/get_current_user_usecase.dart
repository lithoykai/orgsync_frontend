import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class GetCurrentUserUsecase {
  final UserRepository _userRepository;

  GetCurrentUserUsecase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<Either<Failure, UserEntity>> call() async {
    return _userRepository.getCurrentUser();
  }
}
