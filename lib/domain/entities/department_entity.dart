import 'package:orgsync/domain/entities/user_entity.dart';

class DepartmentEntity {
  final int id;
  final String name;
  final String description;
  final Set<UserEntity>? users;

  DepartmentEntity({
    required this.id,
    required this.name,
    required this.description,
    this.users,
  });

  DepartmentEntity copyWith({
    int? id,
    String? name,
    String? description,
    Set<UserEntity>? users,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
    );
  }
}
