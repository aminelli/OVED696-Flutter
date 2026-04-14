/// File: date_formatter.dart
/// 
/// Helper per formattazione date.

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Formatta data in formato "dd/MM/yyyy"
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatta data in formato "dd MMM yyyy" (es: 14 Apr 2026)
  static String formatDateMedium(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formatta data e ora in formato "dd/MM/yyyy HH:mm"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formatta ora in formato "HH:mm"
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Ritorna stringa relativa (es: "2 hours ago", "yesterday")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'yesterday';
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Verifica se la data è oggi
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica se la data è domani
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
