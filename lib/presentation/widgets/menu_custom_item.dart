import 'package:flutter/material.dart';

class MenuCustomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuCustomItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    final isSelected = currentRoute.contains(title.toLowerCase());

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withAlpha(100),
      onTap: onTap,
    );
  }
}
