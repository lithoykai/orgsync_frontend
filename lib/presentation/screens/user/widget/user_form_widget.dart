import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/screens/department/controller/department_controller.dart';
import 'package:orgsync/presentation/screens/user/controller/user_controller.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key, this.user, required this.isEdit});

  final UserEntity? user;
  final bool isEdit;

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  Map<String, dynamic> _formData = {};
  var formKey = GlobalKey<FormState>();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode dropdownFocus = FocusNode();

  final departmentController = getIt<DepartmentController>();
  final usercontroller = getIt<UserController>();
  final authController = getIt<AuthController>();
  List<DepartmentEntity> departments = [];
  String? value;

  @override
  void initState() {
    departmentController.getAllDepartment();
    if (widget.isEdit) {
      value = widget.user!.department!.id.toString();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.user == null) {
      Navigator.of(context).pushReplacementNamed(AppRouter.authOrHome);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    dropdownFocus.dispose();
    super.dispose();
  }

  onSubmitted() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    formKey.currentState?.save();
    try {
      String? id = widget.user?.id;
      if (id == null) return;
      await usercontroller
          .updateUser(
            id,
            _formData['name'],
            _formData['email'] ?? widget.user!.email,
            _formData['password'],
            _formData['departmentId'],
          )
          .then((_) {
            showDialog(
              context: context,
              builder:
                  (dialogContext) => AlertDialog(
                    title: const Text('Usuário atualizado.'),
                    content: Text('Usuário atualizado com sucesso.'),
                    actions: [
                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRouter.usersPage),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: widget.user?.name,
                decoration: InputDecoration(
                  hintText: 'Digite o nome do usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusNode: nameFocus,
                validator: (name) {
                  String _name = name ?? '';
                  if (_name.length < 3) {
                    return 'Nome muito pequeno';
                  }
                  return null;
                },
                onSaved: (name) {
                  _formData['name'] = name;
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Email',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: widget.user?.email,
                decoration: InputDecoration(
                  hintText: 'Digite o email do usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusNode: emailFocus,
                validator: (email) {
                  String _email = email ?? '';
                  if (_email.length < 3) {
                    return 'E-mail muito pequeno';
                  }
                  if (!_email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
                onSaved: (email) {
                  _formData['email'] = email;
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Departamento',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListenableBuilder(
                listenable: departmentController,
                builder: (context, child) {
                  departments = departmentController.departments;
                  return authController.isAdmin
                      ? DropdownButtonFormField<String>(
                        value: value,
                        decoration: InputDecoration(
                          hintText: 'Selecione o departamento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(
                            Icons.business_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusNode: dropdownFocus,

                        items:
                            departments
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (selected) {
                          setState(() {
                            value = selected;
                          });
                        },
                        onSaved: (departmentID) {
                          _formData['departmentId'] = int.tryParse(
                            departmentID ?? 'a',
                          );
                        },
                      )
                      : Container();
                },
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: onSubmitted,
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
