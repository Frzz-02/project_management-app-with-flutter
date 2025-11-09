import 'package:dio/dio.dart';
import 'dashboard_remote_data_source.dart';

/// Dashboard Remote Data Source Implementation
///
/// Implementasi untuk mengambil data dashboard dari API Laravel
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  const DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      print('📡 Calling GET /v1/card untuk stats...');
      // Get all cards untuk hitung statistik
      final response = await dio.get('/v1/card');

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final data = (response.data['data'] ?? []) as List;

        print('📊 Total cards: ${data.length}');

        // Hitung cards yang statusnya "done"
        final doneCards = data.where((card) {
          final status = (card['status'] ?? '').toString().toLowerCase();
          return status == 'done';
        }).toList();

        int completedCount = doneCards.length;
        print('✅ Cards dengan status done: $completedCount');

        // Hitung rata-rata waktu dari assignments yang completed
        int totalMinutes = 0;
        int completedAssignments = 0;

        for (var card in doneCards) {
          final assignments = (card['assignments'] ?? []) as List;

          for (var assignment in assignments) {
            final assignmentStatus = (assignment['assignment_status'] ?? '')
                .toString()
                .toLowerCase();
            final startedAt = assignment['started_at'];
            final completedAt = assignment['completed_at'];

            // Hitung durasi jika assignment completed dan ada started_at & completed_at
            if (assignmentStatus == 'completed' &&
                startedAt != null &&
                completedAt != null) {
              try {
                final startTime = DateTime.parse(startedAt);
                final endTime = DateTime.parse(completedAt);
                final duration = endTime.difference(startTime);

                totalMinutes += duration.inMinutes;
                completedAssignments++;

                print(
                  '⏱️ Assignment ${assignment['id']}: ${duration.inHours}h ${duration.inMinutes % 60}m',
                );
              } catch (e) {
                print(
                  '⚠️ Error parsing time for assignment ${assignment['id']}: $e',
                );
              }
            }
          }
        }

        String averageTime = '0 menit';
        if (completedAssignments > 0) {
          int avgMinutes = totalMinutes ~/ completedAssignments;
          int hours = avgMinutes ~/ 60;
          int minutes = avgMinutes % 60;

          if (hours > 0 && minutes > 0) {
            averageTime = '$hours jam $minutes menit';
          } else if (hours > 0) {
            averageTime = '$hours jam';
          } else {
            averageTime = '$minutes menit';
          }

          print(
            '📊 Rata-rata waktu: $averageTime (dari $completedAssignments assignments)',
          );
        } else {
          print('⚠️ Tidak ada completed assignments dengan waktu valid');
        }

        return {'completed_tasks': completedCount, 'average_time': averageTime};
      }

      print('⚠️ Response tidak valid, returning default');
      return {'completed_tasks': 0, 'average_time': '0 menit'};
    } catch (e) {
      print('❌ Error getting dashboard stats: $e');
      if (e is DioException) {
        print('❌ Dio Error - Status: ${e.response?.statusCode}');
        print('❌ Dio Error - Data: ${e.response?.data}');
        print('❌ Dio Error - Message: ${e.message}');
        print('❌ Dio Error - Request Path: ${e.requestOptions.path}');
      }
      // Return default instead of rethrowing
      return {'completed_tasks': 0, 'average_time': '0 menit'};
    }
  }

  @override
  Future<Map<String, dynamic>?> getOngoingTimer() async {
    try {
      final response = await dio.get('/v1/time-logs/ongoing');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data'] != null) {
          return response.data['data'] as Map<String, dynamic>;
        }
      }

      return null;
    } catch (e) {
      print('❌ Error getting ongoing timer: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeLogs() async {
    try {
      final response = await dio.get('/v1/time-logs');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;
        return data.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
      print('❌ Error getting time logs: $e');
      rethrow;
    }
  }
}
