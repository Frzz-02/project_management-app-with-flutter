import '../../domain/entities/time_log.dart';

/// Base State untuk Time Log Cubit
///
/// Sealed class untuk type-safe pattern matching.
/// Semua state extends dari TimeLogState ini.
///
/// Kenapa pakai sealed class?
/// - Type-safe pattern matching
/// - Compile-time exhaustiveness checking
/// - Clean code tanpa perlu Equatable
sealed class TimeLogState {
  const TimeLogState();
}

/// State awal - Idle
///
/// State ini digunakan saat belum ada time log yang berjalan.
/// User bisa menekan tombol "Start Task" di state ini.
class TimeLogInitial extends TimeLogState {
  const TimeLogInitial();
}

/// State sedang memulai time log
///
/// State ini digunakan saat sedang request ke API untuk start.
/// Ditampilkan loading indicator untuk user feedback.
class TimeLogStarting extends TimeLogState {
  const TimeLogStarting();
}

/// State time log sedang berjalan
///
/// State ini digunakan saat time log berhasil dimulai.
/// Timer akan berjalan dan update elapsedSeconds setiap detik.
/// User bisa menekan tombol "Stop Task" di state ini.
///
/// Properties:
/// - timeLog: Data time log dari API (id, start_time, card info, etc)
/// - elapsedSeconds: Jumlah detik yang sudah berjalan sejak start
class TimeLogRunning extends TimeLogState {
  final TimeLog timeLog;
  final int elapsedSeconds;

  const TimeLogRunning({required this.timeLog, required this.elapsedSeconds});

  /// Helper method untuk format elapsed time ke HH:MM:SS
  ///
  /// Contoh:
  /// - 65 seconds -> "00:01:05"
  /// - 3661 seconds -> "01:01:01"
  String get formattedElapsedTime {
    final hours = elapsedSeconds ~/ 3600;
    final minutes = (elapsedSeconds % 3600) ~/ 60;
    final seconds = elapsedSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

/// State sedang menghentikan time log
///
/// State ini digunakan saat sedang request ke API untuk stop.
/// Ditampilkan loading indicator untuk user feedback.
class TimeLogStopping extends TimeLogState {
  const TimeLogStopping();
}

/// State time log berhasil dihentikan
///
/// State ini digunakan setelah berhasil stop time log.
/// Data timeLog berisi informasi lengkap termasuk duration_minutes.
/// Setelah menampilkan state ini, cubit akan kembali ke Initial.
///
/// Properties:
/// - timeLog: Data time log lengkap dengan end_time dan duration
class TimeLogStopped extends TimeLogState {
  final TimeLog timeLog;

  const TimeLogStopped(this.timeLog);
}

/// State error
///
/// State ini digunakan saat terjadi error (start/stop gagal).
/// Menampilkan pesan error yang readable dari API.
///
/// Properties:
/// - message: Pesan error untuk ditampilkan ke user
class TimeLogError extends TimeLogState {
  final String message;

  const TimeLogError(this.message);
}
