/// File: app_logger.dart
/// 
/// Utility per il logging dell'applicazione.
/// Fornisce metodi per debug, info, warning ed error logging.

import 'package:demo_test/core/config/app_config.dart';

class AppLogger {
  /// Configurazione dell'app
  static AppConfig? _config;

  /// Inizializza il logger con la configurazione dell'app
  static void init(AppConfig config) {
    _config = config;
  }

  /// Log di debug (solo in development/staging)
  static void debug(String message, [dynamic data]) {
    if (_config?.enableDebugLogging ?? false) {
      // ignore: avoid_print
      print('🐛 [DEBUG] $message ${data != null ? '\nData: $data' : ''}');
    }
  }

  /// Log informativo
  static void info(String message, [dynamic data]) {
    if (_config?.enableDebugLogging ?? false) {
      // ignore: avoid_print
      print('ℹ️ [INFO] $message ${data != null ? '\nData: $data' : ''}');
    }
  }

  /// Log di warning
  static void warning(String message, [dynamic data]) {
    if (_config?.enableDebugLogging ?? false) {
      // ignore: avoid_print
      print('⚠️ [WARNING] $message ${data != null ? '\nData: $data' : ''}');
    }
  }

  /// Log di errore
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    // Gli errori vengono sempre loggati
    // ignore: avoid_print
    print('❌ [ERROR] $message');
    if (error != null) {
      // ignore: avoid_print
      print('Error: $error');
    }
    if (stackTrace != null) {
      // ignore: avoid_print
      print('StackTrace: $stackTrace');
    }
  }
}
