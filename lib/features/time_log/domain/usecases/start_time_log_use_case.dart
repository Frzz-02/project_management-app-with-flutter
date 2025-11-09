import '../entities/time_log.dart';
import '../repositories/time_log_repository.dart';

/// Use Case untuk memulai Time Log
///
/// Use case ini digunakan untuk memulai tracking waktu pada card atau subtask.
/// Use case merupakan representasi dari business logic yang spesifik,
/// sehingga memudahkan untuk maintenance dan testing.
///
/// Kenapa pakai use case?
/// - Memisahkan business logic dari presentation layer
/// - Mudah untuk unit testing
/// - Reusable di berbagai tempat
/// - Single Responsibility Principle
class StartTimeLogUseCase {
  final TimeLogRepository repository;

  StartTimeLogUseCase(this.repository);

  /// Execute use case untuk memulai time log
  ///
  /// Method ini akan memanggil repository untuk memulai tracking.
  /// Validasi minimal salah satu (cardId atau subtaskId) harus diisi
  /// dilakukan di layer ini sebelum memanggil repository.
  ///
  /// Parameter:
  /// - cardId: ID card yang akan ditracking (nullable)
  /// - subtaskId: ID subtask yang akan ditracking (nullable)
  /// - description: Deskripsi pekerjaan (optional)
  ///
  /// Returns: Future<TimeLog> yang berisi data time log baru
  /// Throws: Exception jika cardId dan subtaskId null, atau request gagal
  Future<TimeLog> call({
    int? cardId,
    int? subtaskId,
    String? description,
  }) async {
    // Validasi: minimal salah satu harus diisi
    if (cardId == null && subtaskId == null) {
      throw Exception('Minimal salah satu harus diisi: cardId atau subtaskId');
    }

    return await repository.startTimeLog(
      cardId: cardId,
      subtaskId: subtaskId,
      description: description,
    );
  }
}
