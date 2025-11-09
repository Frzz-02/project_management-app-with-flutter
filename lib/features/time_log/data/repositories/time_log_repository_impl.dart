import '../../domain/entities/time_log.dart';
import '../../domain/repositories/time_log_repository.dart';
import '../datasources/time_log_remote_data_source.dart';

/// Implementasi Repository untuk Time Log
///
/// Class ini mengimplementasikan interface TimeLogRepository dari domain layer.
/// Repository bertanggung jawab untuk orchestrate data dari berbagai sumber
/// (dalam kasus ini hanya remote data source).
///
/// Kenapa perlu repository implementation?
/// - Memisahkan interface (contract) dari implementasi
/// - Bisa menggabungkan data dari multiple sources (remote + local)
/// - Mudah untuk testing dengan mock repository
class TimeLogRepositoryImpl implements TimeLogRepository {
  final TimeLogRemoteDataSource remoteDataSource;

  TimeLogRepositoryImpl(this.remoteDataSource);

  /// Implementasi startTimeLog dari interface
  ///
  /// Method ini akan delegate ke remote data source untuk request ke API.
  /// Return type adalah TimeLog (entity dari domain layer), bukan model.
  /// Model otomatis menjadi TimeLog karena model extends entity.
  ///
  /// Parameter:
  /// - cardId: ID card yang akan ditracking (nullable)
  /// - subtaskId: ID subtask yang akan ditracking (nullable)
  /// - description: Deskripsi pekerjaan (optional)
  ///
  /// Returns: Future<TimeLog>
  /// Throws: Exception yang di-throw oleh data source
  @override
  Future<TimeLog> startTimeLog({
    int? cardId,
    int? subtaskId,
    String? description,
  }) async {
    return await remoteDataSource.startTimeLog(
      cardId: cardId,
      subtaskId: subtaskId,
      description: description,
    );
  }

  /// Implementasi stopTimeLog dari interface
  ///
  /// Method ini akan delegate ke remote data source untuk request ke API.
  /// Return type adalah TimeLog (entity dari domain layer), bukan model.
  ///
  /// Parameter:
  /// - timeLogId: ID time log yang akan dihentikan (required)
  /// - description: Deskripsi hasil pekerjaan (optional)
  ///
  /// Returns: Future<TimeLog>
  /// Throws: Exception yang di-throw oleh data source
  @override
  Future<TimeLog> stopTimeLog(int timeLogId, {String? description}) async {
    return await remoteDataSource.stopTimeLog(
      timeLogId,
      description: description,
    );
  }
}
