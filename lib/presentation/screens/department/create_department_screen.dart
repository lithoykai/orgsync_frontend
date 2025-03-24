import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/department/controller/department_controller.dart';
import 'package:orgsync/presentation/screens/department/widget/department_form.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';
import 'package:uuid/uuid.dart';

class CreateDepartmentScreen extends StatefulWidget {
  const CreateDepartmentScreen({super.key});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final uuid = Uuid();
  final controller = getIt<DepartmentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Criar Departamento',
        child: DepartmentForm(
          onSubmit: (String name, String description, Set<String> users) {
            DepartmentEntity newDepartment = DepartmentEntity(
              id: math.Random().nextInt(1000),
              name: name,
              description: description,
            );
            controller.createDepartment(newDepartment, users.toList());
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRouter.departmentsPage);
          },
        ),
      ),
    );
  }
}
