/// File: app_constants.dart
/// 
/// Costanti globali dell'applicazione.
/// Include timeout, limiti, chiavi di storage, etc.

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // API Constants
  static const int defaultPageSize = 20;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyUserToken = 'user_token';
  static const String keyLanguage = 'language';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 30;

  // Routes
  static const String routeHome = '/';
  static const String routeLogin = '/login';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
}
