/// Entry point dell'applicazione Task Manager.
/// 
/// Questa applicazione dimostra l'utilizzo professionale di Navigator 1.0 in Flutter
/// attraverso un caso d'uso reale: la gestione di task.
/// 
/// Funzionalità principali:
/// - Named routes con gestione centralizzata
/// - Passaggio sicuro di argomenti tra schermate
/// - Stack di navigazione controllato
/// - Validazione route e gestione errori
/// - WillPopScope per conferme utente

import 'package:flutter/material.dart';
import 'routes.dart';

/// Punto di ingresso dell'applicazione.
void main() {
  runApp(const TaskManagerApp());
}

/// Widget root dell'applicazione.
/// 
/// Configura:
/// - Tema generale dell'app
/// - Sistema di navigazione con Navigator 1.0
/// - Named routes centralizzate
/// - Handler per route sconosciute
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titolo dell'applicazione
      title: 'Task Manager - Navigator 1.0',

      // Configurazione del tema
      theme: ThemeData(
        // Schema colori basato su un colore primario
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),

        // Usa Material Design 3
        useMaterial3: true,

        // Configurazione AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),

        // Configurazione Card
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Configurazione InputDecoration
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),

        // Configurazione FloatingActionButton
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // CONFIGURAZIONE NAVIGATOR 1.0
      
      // Route iniziale dell'app
      initialRoute: AppRoutes.home,

      // Generatore di route centralizzato
      // Tutte le route passano attraverso questo metodo che:
      // 1. Valida il nome della route
      // 2. Controlla la tipologia degli argomenti
      // 3. Restituisce il widget appropriato
      onGenerateRoute: RouteGenerator.generateRoute,

      // Handler per route non trovate
      // Mostra una schermata di errore user-friendly
      onUnknownRoute: RouteGenerator.onUnknownRoute,
      

      // Debug: mostra il banner "Debug" in development
      debugShowCheckedModeBanner: false,
    );
  }
}

