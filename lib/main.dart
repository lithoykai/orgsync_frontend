import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart' as di;
import 'package:orgsync/presentation/app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const AppWidget());
}
