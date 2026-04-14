/// File: string_extensions.dart
/// 
/// Extension methods per String.

extension StringExtensions on String {
  /// Capitalizza prima lettera
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizza ogni parola
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Verifica se stringa è numerica
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Rimuove tutti gli spazi
  String get removeSpaces {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Tronca stringa a lunghezza max con ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Verifica se stringa è email valida
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Verifica se stringa è URL valida
  bool get isUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }
}
