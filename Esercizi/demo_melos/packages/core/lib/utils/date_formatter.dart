import 'package:intl/intl.dart';

/// Utility per la formattazione delle date in formato leggibile.
///
/// Fornisce metodi statici per formattare DateTime in vari formati
/// adatti alla visualizzazione nell'interfaccia utente.
class DateFormatter {
  DateFormatter._();

  /// Formatter per data completa (es: "15 Aprile 2026")
  static final DateFormat _fullDateFormat = DateFormat('d MMMM yyyy', 'it_IT');

  /// Formatter per data breve (es: "15/04/2026")
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');

  /// Formatter per data e ora (es: "15/04/2026 14:30")
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  /// Formatter per solo ora (es: "14:30")
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Formatta una data in formato completo (es: "15 Aprile 2026").
  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  /// Formatta una data in formato breve (es: "15/04/2026").
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Formatta una data con ora (es: "15/04/2026 14:30").
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Formatta solo l'ora (es: "14:30").
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Formatta una data in modo relativo (es: "Oggi", "Ieri", "15/04/2026").
  ///
  /// - Restituisce "Oggi" se la data è oggi
  /// - Restituisce "Ieri" se la data è ieri
  /// - Restituisce "Domani" se la data è domani
  /// - Altrimenti restituisce la data in formato breve
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Oggi';
    } else if (dateOnly == yesterday) {
      return 'Ieri';
    } else if (dateOnly == tomorrow) {
      return 'Domani';
    } else {
      return formatShortDate(date);
    }
  }

  /// Formatta una data con testo relativo e ora (es: "Oggi 14:30", "Ieri 10:15").
  static String formatRelativeDateTime(DateTime date) {
    return '${formatRelativeDate(date)} ${formatTime(date)}';
  }

  /// Calcola il tempo trascorso in formato umano (es: "2 ore fa", "3 giorni fa").
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Adesso';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? "minuto" : "minuti"} fa';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? "ora" : "ore"} fa';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? "giorno" : "giorni"} fa';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "settimana" : "settimane"} fa';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "mese" : "mesi"} fa';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? "anno" : "anni"} fa';
    }
  }

  /// Verifica se una data è oggi.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica se una data è nel passato.
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Verifica se una data è nel futuro.
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
}
