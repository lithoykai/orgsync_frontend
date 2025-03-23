import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/repository/user_repository.dart';
import 'package:orgsync/infra/failure/failure.dart';

@injectable
class AuthenticateUseCase {
  final UserRepository _repository;

  AuthenticateUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, UserEntity>> call(
    String? name,
    String email,
    String password,
  ) async {
    if (name != null) {
      return await _repository.register(name, email, password);
    }
    return await _repository.login(email, password);
  }
}
