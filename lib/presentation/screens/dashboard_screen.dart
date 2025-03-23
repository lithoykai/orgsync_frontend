import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/widgets/authenticated_layout.dart';
import 'package:orgsync/presentation/widgets/custom_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = getIt<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;

    return AuthenticatedLayout(
      title: 'OrgSync',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao OrgSync',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gerencie seus departamentos e usuários',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            CustomCard(
              title: 'Departamentos',
              icon: Icons.business_outlined,
              subtitle: 'Gerencie os departamentos da sua organização',
              onTap:
                  () => Navigator.of(
                    context,
                  ).pushNamed(AppRouter.departmentsPage),
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: authController,
              builder: (context, child) {
                if (authController.isAdmin) {
                  return CustomCard(
                    title: 'Usuários',
                    icon: Icons.people_outline,
                    subtitle: 'Gerencie os usuários do sistema',
                    onTap:
                        () => Navigator.of(
                          context,
                        ).pushNamed(AppRouter.usersPage),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
