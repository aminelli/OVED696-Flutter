/// File: app_config.dart
/// 
/// Configurazione centralizzata dell'applicazione.
/// Gestisce le variabili d'ambiente e le configurazioni specifiche per flavor.

class AppConfig {
  /// Nome dell'ambiente corrente (dev, stage, prod)
  final String environment;
  
  /// Base URL per le API
  final String apiBaseUrl;
  
  /// API Key per autenticazione
  final String apiKey;
  
  /// Timeout per le richieste API (millisecondi)
  final int apiTimeout;
  
  /// Flag per abilitare analytics
  final bool enableAnalytics;
  
  /// Flag per abilitare crashlytics
  final bool enableCrashlytics;
  
  /// Flag per abilitare logging di debug
  final bool enableDebugLogging;
  
  /// Nome visualizzato dell'app
  final String appName;
  
  /// Versione dell'app
  final String appVersion;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.apiTimeout,
    required this.enableAnalytics,
    required this.enableCrashlytics,
    required this.enableDebugLogging,
    required this.appName,
    required this.appVersion,
  });

  /// Configurazione per ambiente Development
  factory AppConfig.dev() {
    return const AppConfig(
      environment: 'dev',
      apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api-dev.example.com'),
      apiKey: String.fromEnvironment('API_KEY', defaultValue: 'dev-key'),
      apiTimeout: int.fromEnvironment('API_TIMEOUT', defaultValue: 60000),
      enableAnalytics: bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false),
      enableCrashlytics: bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: false),
      enableDebugLogging: bool.fromEnvironment('ENABLE_DEBUG_LOGGING', defaultValue: true),
      appName: String.fromEnvironment('APP_NAME', defaultValue: '[DEV] Demo App'),
      appVersion: String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0-dev'),
    );
  }

  /// Configurazione per ambiente Staging
  factory AppConfig.stage() {
    return const AppConfig(
      environment: 'stage',
      apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api-stage.example.com'),
      apiKey: String.fromEnvironment('API_KEY', defaultValue: 'stage-key'),
      apiTimeout: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000),
      enableAnalytics: bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true),
      enableCrashlytics: bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: true),
      enableDebugLogging: bool.fromEnvironment('ENABLE_DEBUG_LOGGING', defaultValue: true),
      appName: String.fromEnvironment('APP_NAME', defaultValue: '[STAGE] Demo App'),
      appVersion: String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0-stage'),
    );
  }

  /// Configurazione per ambiente Production
  factory AppConfig.prod() {
    return const AppConfig(
      environment: 'prod',
      apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.example.com'),
      apiKey: String.fromEnvironment('API_KEY', defaultValue: ''),
      apiTimeout: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000),
      enableAnalytics: bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true),
      enableCrashlytics: bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: true),
      enableDebugLogging: bool.fromEnvironment('ENABLE_DEBUG_LOGGING', defaultValue: false),
      appName: String.fromEnvironment('APP_NAME', defaultValue: 'Demo App'),
      appVersion: String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),
    );
  }

  /// Verifica se l'ambiente è di development
  bool get isDevelopment => environment == 'dev';

  /// Verifica se l'ambiente è di staging
  bool get isStaging => environment == 'stage';

  /// Verifica se l'ambiente è di production
  bool get isProduction => environment == 'prod';

  @override
  String toString() {
    return 'AppConfig(environment: $environment, apiBaseUrl: $apiBaseUrl)';
  }
}
