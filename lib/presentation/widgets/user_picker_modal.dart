import 'package:flutter/material.dart';
import 'package:orgsync/domain/entities/user_entity.dart';

class UserPickerModal extends StatefulWidget {
  final List<UserEntity> allUsers;
  final Set<String> initialSelected;
  final void Function(Set<String> selectedUsers) onConfirm;

  const UserPickerModal({
    super.key,
    required this.allUsers,
    required this.initialSelected,
    required this.onConfirm,
  });

  @override
  State<UserPickerModal> createState() => _UserPickerModalState();
}

class _UserPickerModalState extends State<UserPickerModal> {
  final Set<String> _selectedUsers = {};
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _selectedUsers.addAll(widget.initialSelected);
  }

  void _toggleUser(UserEntity user) {
    setState(() {
      if (_selectedUsers.contains(user.id)) {
        _selectedUsers.remove(user.id);
      } else {
        _selectedUsers.add(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        widget.allUsers.where((user) {
          return user.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchTerm.toLowerCase());
        }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar usuário...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _searchTerm = value),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child:
                filteredUsers.isEmpty
                    ? const Center(child: Text('Nenhum usuário encontrado'))
                    : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final selected = _selectedUsers.contains(user.id);
                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: selected ? const Icon(Icons.check) : null,
                          onTap: () => _toggleUser(user),
                        );
                      },
                    ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: () {
                  widget.onConfirm(_selectedUsers);
                  Navigator.of(context).pop();
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
