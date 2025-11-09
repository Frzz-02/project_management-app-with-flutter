/// Dashboard Remote Data Source
///
/// Interface untuk operasi data dashboard dari remote API
abstract class DashboardRemoteDataSource {
  /// Get dashboard statistics (completed tasks count, average time)
  Future<Map<String, dynamic>> getDashboardStats();

  /// Get ongoing timer (current task that user is working on)
  Future<Map<String, dynamic>?> getOngoingTimer();

  /// Get all time logs for statistics
  Future<List<Map<String, dynamic>>> getTimeLogs();
}
