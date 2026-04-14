/// File: app.dart
/// 
/// Widget principale dell'applicazione.
/// Configura routing, temi e provider.

import 'package:flutter/material.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/core/theme/app_theme.dart';
import 'package:demo_test/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  /// Configurazione dell'applicazione
  final AppConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDevelopment,
      
      // Temi
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Home page
      home: HomePage(config: config),
    );
  }
}
