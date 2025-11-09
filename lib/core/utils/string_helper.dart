/// Utility class untuk string manipulation
///
/// Class ini berisi helper methods untuk manipulasi string
/// yang sering digunakan di aplikasi
///
class StringHelper {
  /// Private constructor untuk prevent instantiation
  StringHelper._();

  /// Get initials dari nama lengkap
  ///
  /// [name] adalah nama lengkap user
  /// Returns initials (2 huruf pertama dari nama)
  ///
  /// Contoh:
  /// - "John Doe" -> "JD"
  /// - "Alice" -> "AL"
  /// - "Bob Smith Johnson" -> "BS"
  ///
  static String getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.trim().split(' ');

    if (parts.length >= 2) {
      // Ambil huruf pertama dari 2 kata pertama
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      // Ambil 2 huruf pertama jika hanya 1 kata
      final firstWord = parts[0];
      if (firstWord.length >= 2) {
        return firstWord.substring(0, 2).toUpperCase();
      } else {
        return firstWord[0].toUpperCase();
      }
    }
  }

  /// Capitalize first letter dari setiap kata
  ///
  /// [text] adalah string yang akan di-capitalize
  /// Returns string dengan first letter setiap kata uppercase
  ///
  /// Contoh:
  /// - "hello world" -> "Hello World"
  /// - "john doe" -> "John Doe"
  ///
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Capitalize only first letter dari string
  ///
  /// [text] adalah string yang akan di-capitalize
  /// Returns string dengan first letter uppercase
  ///
  /// Contoh:
  /// - "hello world" -> "Hello world"
  /// - "JOHN DOE" -> "John doe"
  ///
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Truncate string dengan ellipsis
  ///
  /// [text] adalah string yang akan di-truncate
  /// [maxLength] adalah panjang maksimal string
  /// Returns truncated string dengan ellipsis jika melebihi maxLength
  ///
  /// Contoh:
  /// - ("Hello World", 5) -> "Hello..."
  /// - ("Hi", 10) -> "Hi"
  ///
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Check apakah string adalah email valid
  ///
  /// [email] adalah string email yang akan divalidasi
  /// Returns true jika email valid
  ///
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Remove extra whitespace dari string
  ///
  /// [text] adalah string yang akan dibersihkan
  /// Returns string tanpa extra whitespace
  ///
  /// Contoh:
  /// - "  Hello   World  " -> "Hello World"
  /// - "Hi\n\nThere" -> "Hi There"
  ///
  static String removeExtraWhitespace(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Convert string ke slug format (lowercase dengan dash)
  ///
  /// [text] adalah string yang akan di-convert
  /// Returns slug string
  ///
  /// Contoh:
  /// - "Hello World" -> "hello-world"
  /// - "My New Project" -> "my-new-project"
  ///
  static String toSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Mask string untuk keamanan (contoh: password, email)
  ///
  /// [text] adalah string yang akan di-mask
  /// [visibleStart] adalah jumlah karakter visible di awal
  /// [visibleEnd] adalah jumlah karakter visible di akhir
  /// Returns masked string
  ///
  /// Contoh:
  /// - ("john@example.com", 2, 4) -> "jo*****e.com"
  /// - ("password123", 2, 0) -> "pa*********"
  ///
  static String maskString(
    String text, {
    int visibleStart = 2,
    int visibleEnd = 0,
  }) {
    if (text.length <= visibleStart + visibleEnd) return text;

    final start = text.substring(0, visibleStart);
    final end = visibleEnd > 0 ? text.substring(text.length - visibleEnd) : '';
    final middle = '*' * (text.length - visibleStart - visibleEnd);

    return '$start$middle$end';
  }
}
