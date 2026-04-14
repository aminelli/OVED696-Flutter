/// Entry point dell'applicazione mobile per la gestione task.
library;

import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TaskMobileApp());
}

/// Widget root dell'applicazione.
///
/// Configura il tema e il routing dell'app.
class TaskMobileApp extends StatelessWidget {
  const TaskMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
