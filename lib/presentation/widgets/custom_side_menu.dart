import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/widgets/menu_custom_item.dart';

class CustomSideMenu extends StatelessWidget {
  bool isMobile;
  CustomSideMenu({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = getIt<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final menuWidth = width * 0.2;

    return Container(
      width:
          isMobile
              ? menuWidth.clamp(300.0, 500.0)
              : menuWidth.clamp(200.0, 300.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 32, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'OrgSync',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    MenuCustomItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      onTap:
                          () => Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRouter.dashboardPage),
                    ),
                    MenuCustomItem(
                      icon: Icons.business_outlined,
                      title: 'Departamentos',
                      onTap:
                          () => Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRouter.departmentsPage),
                    ),
                    controller.isAdmin
                        ? MenuCustomItem(
                          icon: Icons.people_outline,
                          title: 'Usuários',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).pushReplacementNamed(AppRouter.usersPage),
                        )
                        : Container(),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Editar Perfil'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap:
                      () => Navigator.of(context).pushNamed(
                        AppRouter.usersEditPage,
                        arguments: controller.currentUser,
                      ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text(
                    'Desconectar',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () async {
                    await controller.logout();
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRouter.authOrHome);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
