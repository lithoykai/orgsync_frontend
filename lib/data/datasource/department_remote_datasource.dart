import 'package:orgsync/data/models/department_model.dart';

abstract interface class DepartmentRemoteDatasource {
  Future<List<DepartmentModel>> getDepartments();
  Future<DepartmentModel> getDepartment(int id);
  Future<void> createDepartment(DepartmentModel department, List<String> users);
  Future<DepartmentModel> updateDepartment(DepartmentModel department);
  Future<void> deleteDepartment(int id);
  Future<DepartmentModel> addUsersInDepartment(
    int departmentId,
    List<String> userId,
  );
  Future<DepartmentModel> removeUserInDepartment(
    int departmentId,
    List<String> userId,
  );
}
