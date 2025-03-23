import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/screens/department/controller/department_controller.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  final controller = getIt<DepartmentController>();
  final authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.getAllDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Departamentos',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lista de Departamentos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gerencie os departamentos da sua organização',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              ListenableBuilder(
                listenable: controller,
                builder: (ctx, child) {
                  if (controller.departments.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<DepartmentEntity> departments = controller.departments;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.business_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          departments[index].name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${departments[index].users!.length} colaborador${departments[index].users!.length > 1 ? 'es' : ''}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  authController.isAdmin
                                      ? IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pushNamed(
                                                  AppRouter.departmentsEditPage,
                                                  arguments: departments[index],
                                                ),
                                      )
                                      : Container(),
                                  IconButton(
                                    icon: const Icon(Icons.people_outline),
                                    onPressed:
                                        () => Navigator.of(context).pushNamed(
                                          AppRouter.departmentsUsersPage,
                                          arguments: departments[index],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          authController.isAdmin
              ? FloatingActionButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRouter.createDepartment),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
