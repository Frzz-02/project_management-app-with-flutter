/// Utility class untuk format date
///
/// Class ini berisi helper methods untuk formatting tanggal
/// dalam berbagai format yang dibutuhkan aplikasi
///
class DateFormatter {
  /// Private constructor untuk prevent instantiation
  DateFormatter._();

  /// Format date string ke format DD/MM/YYYY
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns formatted date string (DD/MM/YYYY)
  ///
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Format date string ke format DD MMM YYYY (contoh: 15 Jan 2024)
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns formatted date string (DD MMM YYYY)
  ///
  static String formatDateWithMonth(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Format DateTime ke format DD/MM/YYYY
  ///
  /// [date] adalah DateTime object
  /// Returns formatted date string (DD/MM/YYYY)
  ///
  static String formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format DateTime ke format DD MMM YYYY HH:MM
  ///
  /// [date] adalah DateTime object
  /// Returns formatted date time string (DD MMM YYYY HH:MM)
  ///
  static String formatDateTimeWithTime(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year} $hour:$minute';
  }

  /// Get relative time (contoh: "2 days ago", "Just now")
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns relative time string
  ///
  static String getRelativeTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Check apakah date sudah overdue
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns true jika date sudah lewat dari hari ini
  ///
  static bool isOverdue(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return targetDate.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  /// Get jumlah hari tersisa hingga due date
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns jumlah hari (negatif jika sudah lewat)
  ///
  static int getDaysRemaining(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return targetDate.difference(today).inDays;
    } catch (e) {
      return 0;
    }
  }
}
