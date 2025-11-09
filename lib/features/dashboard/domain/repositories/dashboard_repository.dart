/// Dashboard Repository
///
/// Interface repository untuk operasi data dashboard
abstract class DashboardRepository {
  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats();

  /// Get ongoing timer
  Future<Map<String, dynamic>?> getOngoingTimer();

  /// Get time logs
  Future<List<Map<String, dynamic>>> getTimeLogs();
}
