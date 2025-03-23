import 'package:flutter/material.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/auth_or_home.dart';
import 'package:orgsync/presentation/screens/auth/login_screen.dart';
import 'package:orgsync/presentation/screens/auth/register_screen.dart';
import 'package:orgsync/presentation/screens/dashboard_screen.dart';
import 'package:orgsync/presentation/screens/department/create_department_screen.dart';
import 'package:orgsync/presentation/screens/department/department_edit_screen.dart';
import 'package:orgsync/presentation/screens/department/department_list_screen.dart';
import 'package:orgsync/presentation/screens/department/department_users_screen.dart';
import 'package:orgsync/presentation/screens/user/user_edit_screen.dart';
import 'package:orgsync/presentation/screens/user/user_list_screen.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrgSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: AppRouter.authOrHome,
      routes: {
        AppRouter.authOrHome: (context) => const AuthOrHomePage(),
        AppRouter.dashboardPage: (context) => const DashboardScreen(),
        AppRouter.departmentsPage: (context) => const DepartmentListScreen(),
        AppRouter.registerPage: (context) => const RegisterScreen(),
        AppRouter.loginPage: (context) => const LoginScreen(),
        AppRouter.usersPage: (context) => const UserListScreen(),
        AppRouter.departmentsEditPage:
            (context) => const DepartmentEditScreen(),
        AppRouter.departmentsUsersPage:
            (context) => const DepartmentUsersScreen(),
        AppRouter.usersEditPage: (context) => UserEditScreen(),
        AppRouter.createDepartment: (context) => CreateDepartmentScreen(),
      },
    );
  }
}
