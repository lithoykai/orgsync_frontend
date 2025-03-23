import 'package:injectable/injectable.dart';
import 'package:orgsync/data/datasource/client/http_service.dart';
import 'package:orgsync/data/datasource/department_remote_datasource.dart';
import 'package:orgsync/data/models/department_model.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/entities/user_entity.dart';

@Injectable(as: DepartmentRemoteDatasource)
class DepartmentRemoteDatasourceImpl implements DepartmentRemoteDatasource {
  HttpService _httpService;

  DepartmentRemoteDatasourceImpl({required HttpService httpService})
    : _httpService = httpService;

  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await _httpService.get('/api/department/all');
      return (response.data as List)
          .map((e) => DepartmentModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<DepartmentModel> getDepartment(int id) async {
    try {
      final response = await _httpService.get('/api/department/id/$id');
      return DepartmentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DepartmentModel> createDepartment(DepartmentModel department) async {
    try {
      final response = await _httpService.post(
        '/api/department',
        data: department.toJson(),
      );
      return DepartmentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DepartmentModel> updateDepartment(DepartmentModel department) async {
    try {
      final response = await _httpService.put(
        '/api/department/${department.id}',
        data: department.toJson(),
      );
      return DepartmentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await _httpService.delete('/api/department/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<DepartmentModel> addUsersInDepartment(
    int departmentId,
    List<String> userId,
  ) async {
    try {
      final response = await _httpService.post(
        '/api/department/users/$departmentId',
        data: {'users': userId},
      );
      return DepartmentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DepartmentModel> removeUserInDepartment(
    int departmentId,
    List<String> userId,
  ) async {
    try {
      final response = await _httpService.put(
        '/api/department/remove/$departmentId',
        data: {"users": userId},
      );

      return DepartmentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
