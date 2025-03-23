import 'package:flutter/material.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/presentation/screens/department/widget/department_form.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';

class DepartmentEditScreen extends StatelessWidget {
  const DepartmentEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final department =
        ModalRoute.of(context)?.settings.arguments as DepartmentEntity?;

    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Editar Departamento',
        child: DepartmentForm(
          initialDepartment: department,
          onSubmit: (String name, String description, Set<String> users) {
            // TODO: Atualizar departamento via controller
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
