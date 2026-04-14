/// Utility per la validazione di input dell'utente.
///
/// Fornisce metodi statici per validare email, password, nomi
/// e altri tipi di input comuni nell'applicazione.
class Validators {
  Validators._();

  /// Pattern regex per validazione email.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Pattern regex per password forte (almeno 8 caratteri, 1 maiuscola, 1 numero).
  static final RegExp _strongPasswordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$',
  );

  /// Pattern regex per nomi validi (solo lettere e spazi).
  static final RegExp _nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");

  /// Valida un indirizzo email.
  ///
  /// Restituisce `null` se l'email è valida, altrimenti un messaggio di errore.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email richiesta';
    }

    if (!_emailRegex.hasMatch(value)) {
      return 'Inserisci un\'email valida';
    }

    return null;
  }

  /// Valida una password.
  ///
  /// [requireStrong] se true, richiede password forte (default: true).
  /// Restituisce `null` se la password è valida, altrimenti un messaggio di errore.
  static String? validatePassword(String? value, {bool requireStrong = true}) {
    if (value == null || value.isEmpty) {
      return 'Password richiesta';
    }

    if (value.length < 6) {
      return 'Password troppo corta (minimo 6 caratteri)';
    }

    if (requireStrong && !_strongPasswordRegex.hasMatch(value)) {
      return 'Password debole. Usa almeno 8 caratteri, una maiuscola e un numero';
    }

    return null;
  }

  /// Valida un nome (nome o cognome).
  ///
  /// Restituisce `null` se il nome è valido, altrimenti un messaggio di errore.
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome richiesto';
    }

    if (value.length < 2) {
      return 'Nome troppo corto (minimo 2 caratteri)';
    }

    if (!_nameRegex.hasMatch(value)) {
      return 'Nome non valido. Usa solo lettere';
    }

    return null;
  }

  /// Valida un campo di testo generico non vuoto.
  ///
  /// [fieldName] è il nome del campo da mostrare nel messaggio di errore.
  /// [minLength] è la lunghezza minima richiesta (default: 1).
  static String? validateRequired(
    String? value, {
    String fieldName = 'Campo',
    int minLength = 1,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName richiesto';
    }

    if (value.length < minLength) {
      return '$fieldName troppo corto (minimo $minLength caratteri)';
    }

    return null;
  }

  /// Valida un numero di telefono italiano.
  ///
  /// Accetta formati come: +39 xxx xxx xxxx, 3xx xxx xxxx, +393xxxxxxxxx
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numero di telefono richiesto';
    }

    // Rimuovi spazi e caratteri speciali
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-()]'), '');

    // Pattern per numeri italiani
    final phoneRegex = RegExp(r'^(\+39)?3\d{8,9}$');

    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Numero di telefono non valido';
    }

    return null;
  }

  /// Valida un URL.
  ///
  /// Verifica che il formato sia valido e che inizi con http:// o https://
  static String? validateUrl(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL richiesto' : null;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL non valido';
    }

    return null;
  }

  /// Valida che due campi siano uguali (utile per conferma password).
  ///
  /// [fieldName] è il nome del campo da confermare.
  static String? validateMatch(
    String? value,
    String? otherValue, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName richiesto';
    }

    if (value != otherValue) {
      return '$fieldName non coincide';
    }

    return null;
  }

  /// Valida una lunghezza minima e massima.
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName richiesto';
    }

    if (minLength != null && value.length < minLength) {
      return '$fieldName troppo corto (minimo $minLength caratteri)';
    }

    if (maxLength != null && value.length > maxLength) {
      return '$fieldName troppo lungo (massimo $maxLength caratteri)';
    }

    return null;
  }
}
