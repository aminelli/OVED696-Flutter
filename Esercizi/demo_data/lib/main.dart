/// Applicazione Flutter Demo Data Storage
/// 
/// Questa app dimostra 5 diverse tecnologie di persistenza dati in Flutter:
/// 1. File System (path_provider)
/// 2. SharedPreferences
/// 3. Flutter Secure Storage
/// 4. SQLite Database (sqflite)
/// 5. Hive Database (hive)
/// 
/// Ogni demo include esempi pratici e best practices.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'services/hive_service.dart';
import 'screens/home_screen.dart';

void main() async {
  // Inizializza Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza sqflite per desktop (Windows, Linux, macOS)
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      if (kDebugMode) {
        print('✓ SQLite FFI initialized for desktop');
      }
    }
  }
  
  // Inizializza Hive (funziona su tutte le piattaforme)
  try {
    await HiveService.init();
    if (kDebugMode) {
      print('✓ Hive initialized');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Hive: $e');
    }
  }
  
  runApp(const MyApp());
}

/// Widget principale dell'applicazione
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Data Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
