import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/department/controller/department_controller.dart';
import 'package:orgsync/presentation/screens/department/widget/department_form.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';

class DepartmentEditScreen extends StatefulWidget {
  const DepartmentEditScreen({super.key});

  @override
  State<DepartmentEditScreen> createState() => _DepartmentEditScreenState();
}

class _DepartmentEditScreenState extends State<DepartmentEditScreen> {
  get uuid => null;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<DepartmentController>();
    final department =
        ModalRoute.of(context)?.settings.arguments as DepartmentEntity?;

    if (department == null) {
      Future.microtask(() {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRouter.dashboardPage);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Editar Departamento',
        child: DepartmentForm(
          initialDepartment: department,
          onSubmit: (String name, String description, Set<String> users) {
            DepartmentEntity newDepartment = DepartmentEntity(
              id: department.id,
              name: name,
              description: description,
            );
            controller.updateDepartment(newDepartment, users.toList());
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRouter.departmentsPage);
          },
        ),
      ),
    );
  }
}
