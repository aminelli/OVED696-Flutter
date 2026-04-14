/// File: main_dev.dart
/// 
/// Entry point per l'ambiente Development.
/// Avvia l'applicazione con configurazione dev.

import 'package:flutter/material.dart';
import 'package:demo_test/app.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/core/utils/app_logger.dart';

void main() {
  // Inizializza configurazione Development
  final config = AppConfig.dev();
  
  // Inizializza logger
  AppLogger.init(config);
  
  // Log avvio applicazione
  AppLogger.info('Starting app in DEVELOPMENT mode');
  AppLogger.debug('Configuration', config.toString());

  runApp(MyApp(config: config));
}
