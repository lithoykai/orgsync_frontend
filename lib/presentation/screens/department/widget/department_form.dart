import 'dart:math';

import 'package:flutter/material.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/presentation/widgets/custom_text_field.dart';

class DepartmentForm extends StatefulWidget {
  final DepartmentEntity? initialDepartment;
  final void Function(String name, String description, Set<String> users)
  onSubmit;

  const DepartmentForm({
    super.key,
    this.initialDepartment,
    required this.onSubmit,
  });

  @override
  State<DepartmentForm> createState() => _DepartmentFormState();
}

class _DepartmentFormState extends State<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Set<UserEntity> _selectedUsers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialDepartment != null) {
      _nameController.text = widget.initialDepartment!.name;
      _descriptionController.text = widget.initialDepartment!.description;
    }
  }

  void _openUserPickerModal() async {
    final List<UserEntity> users = []; // TODO: buscar usuários

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar usuário',
                      ),
                      onChanged: (value) {
                        // TODO: buscar usuários pelo nome
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final selected = _selectedUsers.contains(user);
                          return ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: selected ? const Icon(Icons.check) : null,
                            onTap: () {
                              setModalState(() {
                                if (selected) {
                                  _selectedUsers.remove(user);
                                } else {
                                  _selectedUsers.add(user);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _selectedUsers.map((e) => e.id).toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Nome',
                controller: _nameController,
                validator:
                    (value) =>
                        value == null || value.trim().length < 3
                            ? 'Nome inválido'
                            : null,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Descrição',
                controller: _descriptionController,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _openUserPickerModal,
                icon: const Icon(Icons.people_outline),
                label: const Text('Adicionar usuários'),
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
                  FilledButton(onPressed: _submit, child: const Text('Salvar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
