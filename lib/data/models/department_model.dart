import 'package:orgsync/data/models/user_model.dart';
import 'package:orgsync/domain/entities/department_entity.dart';

class DepartmentModel {
  final int id;
  final String name;
  final String description;
  final Set<UserModel>? users;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    this.users,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      users:
          json['users'] != null
              ? (json['users'] as List)
                  .map((e) => UserModel.fromJson(e))
                  .toSet()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'users': users?.toList()};
  }

  DepartmentModel copyWith({
    int? id,
    String? name,
    String? description,
    Set<UserModel>? users,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
    );
  }

  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      users: entity.users?.map((e) => UserModel.fromEntity(e)).toSet(),
    );
  }

  DepartmentEntity toEntity() {
    return DepartmentEntity(
      id: id,
      name: name,
      description: description,
      users: users?.map((e) => e.toEntity()).toSet(),
    );
  }
}
