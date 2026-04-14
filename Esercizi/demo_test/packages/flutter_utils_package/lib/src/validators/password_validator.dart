/// File: password_validator.dart
/// 
/// Validatore per password con vari criteri.

class PasswordValidator {
  PasswordValidator._();

  /// Lunghezza minima password
  static const int minLength = 8;

  /// Verifica se password ha lunghezza minima
  static bool hasMinLength(String? password) {
    return password != null && password.length >= minLength;
  }

  /// Verifica se password contiene almeno una lettera maiuscola
  static bool hasUppercase(String? password) {
    if (password == null) return false;
    return password.contains(RegExp(r'[A-Z]'));
  }

  /// Verifica se password contiene almeno una lettera minuscola
  static bool hasLowercase(String? password) {
    if (password == null) return false;
    return password.contains(RegExp(r'[a-z]'));
  }

  /// Verifica se password contiene almeno un numero
  static bool hasDigit(String? password) {
    if (password == null) return false;
    return password.contains(RegExp(r'[0-9]'));
  }

  /// Verifica se password contiene almeno un carattere speciale
  static bool hasSpecialChar(String? password) {
    if (password == null) return false;
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  /// Valida password con criteri standard
  static String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (!hasMinLength(password)) {
      return 'Password must be at least $minLength characters';
    }

    if (!hasUppercase(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!hasLowercase(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!hasDigit(password)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Calcola forza password (0-100)
  static int calculateStrength(String? password) {
    if (password == null || password.isEmpty) return 0;

    var strength = 0;

    if (hasMinLength(password)) strength += 20;
    if (password.length >= 12) strength += 10;
    if (hasUppercase(password)) strength += 20;
    if (hasLowercase(password)) strength += 20;
    if (hasDigit(password)) strength += 15;
    if (hasSpecialChar(password)) strength += 15;

    return strength.clamp(0, 100);
  }
}
