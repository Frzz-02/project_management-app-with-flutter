import '../data_sources/dashboard_remote_data_source.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Dashboard Repository Implementation
///
/// Implementasi repository untuk dashboard
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      return await remoteDataSource.getDashboardStats();
    } catch (e) {
      print('❌ Error di DashboardRepository getDashboardStats: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getOngoingTimer() async {
    try {
      return await remoteDataSource.getOngoingTimer();
    } catch (e) {
      print('❌ Error di DashboardRepository getOngoingTimer: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeLogs() async {
    try {
      return await remoteDataSource.getTimeLogs();
    } catch (e) {
      print('❌ Error di DashboardRepository getTimeLogs: $e');
      rethrow;
    }
  }
}
