import 'package:orgsync/data/models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUser();
  Future<void> updateUser(
    String id,
    String name,
    String email,
    String? password,
    int? departmentId,
  );
  Future<void> deleteUser(String id);
}
