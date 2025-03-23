import 'package:flutter/material.dart';
import 'package:orgsync/presentation/screens/department/widget/department_form.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';

class CreateDepartmentScreen extends StatelessWidget {
  const CreateDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Criar Departamento',
        child: DepartmentForm(
          onSubmit: (String name, String description, Set<String> users) {
            // TODO: Criar novo departamento via controller
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
