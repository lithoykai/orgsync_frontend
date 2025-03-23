import 'package:orgsync/data/models/department_model.dart';
import 'package:orgsync/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final int roleId;
  final DepartmentModel? departmentModel;
  bool? enabled = true;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roleId,
    this.departmentModel,

    this.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleId: json['roles'][0]['roleId'],
      departmentModel:
          json['department'] != null
              ? DepartmentModel.fromJson(json['department'])
              : null,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      department: departmentModel?.toEntity(),
      enabled: enabled,
      roleId: roleId,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      roleId: entity.roleId,
      departmentModel:
          entity.department != null
              ? DepartmentModel.fromEntity(entity.department!)
              : null,
      enabled: entity.enabled,
    );
  }
}
