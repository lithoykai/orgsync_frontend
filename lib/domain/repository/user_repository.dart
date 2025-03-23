import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/infra/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class UserRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, List<UserEntity>>> getAllUser();
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> updateUser(
    String id,
    String name,
    String email,
    String? password,
    int? departmentId,
  );
  Future<Either<Failure, void>> deleteUser(String id);
}
