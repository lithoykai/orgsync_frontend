import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/screens/department/controller/department_controller.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';

class DepartmentUsersScreen extends StatefulWidget {
  const DepartmentUsersScreen({super.key});

  @override
  State<DepartmentUsersScreen> createState() => _DepartmentUsersScreenState();
}

class _DepartmentUsersScreenState extends State<DepartmentUsersScreen> {
  DepartmentEntity? department;
  final authController = getIt<AuthController>();
  final controller = getIt<DepartmentController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null && arg is DepartmentEntity) {
      department = arg;
    }
  }

  _removeUserDepartmentUsecase(String id) async {
    try {
      await controller.removeUserInDepartment(department!.id, id).then((_) {
        showDialog(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: const Text('Usuário movido'),
                content: Text("O usuário foi movido para 'Sem Departamento'."),
                actions: [
                  TextButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamed(AppRouter.departmentsPage),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
        );
      });
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Erro'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticatedLayout(
        title: 'Colaboradores do Departamento',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Colaboradores do Departamento',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gerencie os colaboradores deste departamento',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: department?.users?.length ?? 0,
                itemBuilder: (context, index) {
                  UserEntity? user = department?.users!.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user!.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user!.email,
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
                              authController.currentUser?.roleId == 1
                                  ? Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          UserEntity newUser = UserEntity(
                                            id: user.id,
                                            name: user.name,
                                            email: user.email,
                                            roleId: user.roleId,
                                            department: department,
                                          );
                                          Navigator.of(context).pushNamed(
                                            AppRouter.usersEditPage,
                                            arguments: newUser,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (dialogContext) => AlertDialog(
                                                  title: const Text(
                                                    'Deseja remover esse usuário desse departamento?',
                                                  ),
                                                  content: Text(
                                                    "O colaborador será movido para o 'Sem departamento'.",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () =>
                                                              _removeUserDepartmentUsecase(
                                                                user.id,
                                                              ),
                                                      child: const Text('Sim'),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () =>
                                                              Navigator.of(
                                                                context,
                                                              ).pop(),
                                                      child: const Text('Não'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                onPressed: () {},
                child: const Icon(Icons.person_add),
              )
              : null,
    );
  }
}
