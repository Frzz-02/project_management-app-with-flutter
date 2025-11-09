import '../entities/time_log.dart';

/// Interface Repository untuk Time Log
///
/// Interface ini mendefinisikan kontrak untuk operasi time log.
/// Implementasi dilakukan di data layer (TimeLogRepositoryImpl).
/// Dengan menggunakan interface, kita memisahkan business logic dari
/// detail implementasi, sehingga lebih mudah untuk testing dan maintenance.
///
/// Kenapa di domain layer?
/// - Domain layer berisi business rules dan tidak bergantung pada framework
/// - Repository interface adalah bagian dari business logic
/// - Implementation-nya ada di data layer yang bisa diganti sewaktu-waktu
abstract class TimeLogRepository {
  /// Memulai tracking waktu untuk card atau subtask
  ///
  /// Method ini akan mengirim request ke API untuk memulai time tracking.
  /// User harus mengisi minimal salah satu: cardId atau subtaskId.
  ///
  /// Parameter:
  /// - cardId: ID card yang akan ditracking (nullable)
  /// - subtaskId: ID subtask yang akan ditracking (nullable)
  /// - description: Deskripsi apa yang akan dikerjakan (optional)
  ///
  /// Returns: Future<TimeLog> berisi data time log yang baru dibuat
  /// Throws: Exception jika request gagal atau validation error
  Future<TimeLog> startTimeLog({
    int? cardId,
    int? subtaskId,
    String? description,
  });

  /// Menghentikan tracking waktu yang sedang berjalan
  ///
  /// Method ini akan mengirim request ke API untuk menghentikan time tracking.
  /// API akan menghitung durasi otomatis berdasarkan start_time.
  ///
  /// Parameter:
  /// - timeLogId: ID time log yang akan dihentikan (required)
  /// - description: Deskripsi pekerjaan yang sudah diselesaikan (optional)
  ///
  /// Returns: Future<TimeLog> berisi data time log dengan durasi
  /// Throws: Exception jika request gagal
  Future<TimeLog> stopTimeLog(int timeLogId, {String? description});
}
