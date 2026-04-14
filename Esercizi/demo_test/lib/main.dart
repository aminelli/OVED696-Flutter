/// File: main.dart
/// 
/// Entry point predefinito per l'ambiente Development.
/// Per altri ambienti usare main_dev.dart, main_stage.dart, main_prod.dart

import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/app_config.dart';

void main() {
  // Configurazione Development di default
  final config = AppConfig.dev();
  
  runApp(MyApp(config: config));
}
