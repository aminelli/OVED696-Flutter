/// File: main_prod.dart
/// 
/// Entry point per l'ambiente Production.
/// Avvia l'applicazione con configurazione prod.

import 'package:flutter/material.dart';
import 'package:demo_test/app.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/core/utils/app_logger.dart';

void main() {
  // Inizializza configurazione Production
  final config = AppConfig.prod();
  
  // Inizializza logger
  AppLogger.init(config);
  
  // Log avvio applicazione
  AppLogger.info('Starting app in PRODUCTION mode');

  runApp(MyApp(config: config));
}
