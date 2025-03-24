import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:orgsync/data/datasource/client/http_service.dart';
import 'package:orgsync/data/datasource/user_remote_datasource.dart';
import 'package:orgsync/data/models/user_model.dart';
import 'package:orgsync/domain/services/token_provider.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDatasourceImpl implements UserRemoteDataSource {
  final HttpService _http;
  final TokenProvider _tokenProvider;

  UserRemoteDatasourceImpl({
    required HttpService http,
    required TokenProvider tokenProvider,
  }) : _http = http,
       _tokenProvider = tokenProvider;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _http.get("/api/users/all");
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.data,
      );
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _http.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      Map<String, dynamic> data = response.data;

      Map<String, dynamic> token = {
        'accessToken': data['accessToken'],
        'expiresIn':
            DateTime.now()
                .add(Duration(seconds: data['expiresIn']))
                .toIso8601String(),
      };
      await _tokenProvider.setToken(jsonEncode(token));
      final user = await getUser();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await _http.post(
        "/auth/register",
        data: {"name": name, "email": email, "password": password},
      );
      if (response.statusCode == 201) {
        final user = await login(email, password);
        return user;
      } else {
        throw Exception("Falha em registrar usuário");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _http.get("/api/users/");
      Map<String, dynamic> data = response.data;
      return UserModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUser(
    String id,
    String name,
    String email,
    String? password,
    int? departmentId,
  ) async {
    try {
      final response = await _http.put(
        '/api/users/edit',
        data: {"id": id, "name": name, "email": email, "password": password},
      );

      if (response.statusCode == 200 && departmentId != null) {
        await _http.put(
          "/api/department/users/$departmentId",
          data: {
            "users": [id],
          },
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _http.delete('/api/users/$id');
    } catch (e) {
      rethrow;
    }
  }
}
