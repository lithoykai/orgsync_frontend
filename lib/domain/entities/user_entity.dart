import 'package:orgsync/domain/entities/department_entity.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final int roleId;
  final DepartmentEntity? department;
  bool? enabled = true;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.roleId,
    this.department,
    this.enabled,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    DepartmentEntity? department,
    int? roleId,
    bool? enabled,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      roleId: roleId ?? this.roleId,
      enabled: enabled ?? this.enabled,
    );
  }
}
