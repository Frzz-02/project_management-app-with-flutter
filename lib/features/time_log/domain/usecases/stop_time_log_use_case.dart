import '../entities/time_log.dart';
import '../repositories/time_log_repository.dart';

/// Use Case untuk menghentikan Time Log
///
/// Use case ini digunakan untuk menghentikan tracking waktu yang sedang berjalan.
/// API akan menghitung durasi otomatis berdasarkan waktu mulai dan waktu stop.
///
/// Kenapa pakai use case?
/// - Memisahkan business logic dari presentation layer
/// - Mudah untuk unit testing
/// - Reusable di berbagai tempat
/// - Single Responsibility Principle
class StopTimeLogUseCase {
  final TimeLogRepository repository;

  StopTimeLogUseCase(this.repository);

  /// Execute use case untuk menghentikan time log
  ///
  /// Method ini akan memanggil repository untuk menghentikan tracking.
  /// Validasi timeLogId dilakukan di layer ini.
  ///
  /// Parameter:
  /// - timeLogId: ID time log yang akan dihentikan (required)
  /// - description: Deskripsi hasil pekerjaan (optional)
  ///
  /// Returns: Future<TimeLog> yang berisi data time log lengkap dengan durasi
  /// Throws: Exception jika timeLogId invalid atau request gagal
  Future<TimeLog> call(int timeLogId, {String? description}) async {
    // Validasi: timeLogId harus valid
    if (timeLogId <= 0) {
      throw Exception('Time Log ID tidak valid');
    }

    return await repository.stopTimeLog(timeLogId, description: description);
  }
}
