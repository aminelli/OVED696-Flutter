/// File: main_stage.dart
/// 
/// Entry point per l'ambiente Staging.
/// Avvia l'applicazione con configurazione stage.

import 'package:flutter/material.dart';
import 'package:demo_test/app.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/core/utils/app_logger.dart';

void main() {
  // Inizializza configurazione Staging
  final config = AppConfig.stage();
  
  // Inizializza logger
  AppLogger.init(config);
  
  // Log avvio applicazione
  AppLogger.info('Starting app in STAGING mode');
  AppLogger.debug('Configuration', config.toString());

  runApp(MyApp(config: config));
}
