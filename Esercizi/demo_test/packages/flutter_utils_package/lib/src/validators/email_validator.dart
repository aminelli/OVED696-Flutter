/// File: email_validator.dart
/// 
/// Validatore per email addresses.

class EmailValidator {
  // Prevent instantiation
  EmailValidator._();

  // Regex per validazione email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Valida se una stringa è un'email valida
  /// 
  /// Returns: true se valida, false altrimenti
  static bool isValid(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    
    return _emailRegex.hasMatch(email.trim());
  }

  /// Valida email e ritorna messaggio di errore se non valida
  /// 
  /// Returns: null se valida, messaggio di errore altrimenti
  static String? validate(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    
    if (!isValid(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
}
