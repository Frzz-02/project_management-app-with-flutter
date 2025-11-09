import 'package:dio/dio.dart';
import '../models/time_log_model.dart';

/// Remote Data Source untuk Time Log
///
/// Class ini bertanggung jawab untuk komunikasi dengan API.
/// Menggunakan Dio client yang sudah dikonfigurasi dengan AuthInterceptor.
/// Semua exception dari Dio di-catch dan di-convert ke pesan yang readable.
///
/// Kenapa perlu data source?
/// - Memisahkan logic HTTP dari repository
/// - Mudah untuk testing dengan mock
/// - Single Responsibility: hanya handle API calls
class TimeLogRemoteDataSource {
  final Dio dio;

  TimeLogRemoteDataSource(this.dio);

  /// Memulai time log via API
  ///
  /// Endpoint: POST /v1/time-logs/start
  /// Request body:
  /// {
  ///   "card_id": 123,        // optional, minimal salah satu
  ///   "subtask_id": 456,     // optional, minimal salah satu
  ///   "description": "..."   // optional
  /// }
  ///
  /// Response:
  /// {
  ///   "success": true,
  ///   "message": "Time log started successfully",
  ///   "data": {
  ///     "id": 789,
  ///     "card_id": 123,
  ///     "card_title": "Fix bug",
  ///     "board_name": "Development",
  ///     "subtask_id": null,
  ///     "subtask_name": null,
  ///     "start_time": "2024-01-20T10:00:00Z",
  ///     "end_time": null,
  ///     "description": "Working on bug fix",
  ///     "duration_minutes": null,
  ///     "duration_formatted": null
  ///   }
  /// }
  ///
  /// Parameter:
  /// - cardId: ID card yang akan ditracking (nullable)
  /// - subtaskId: ID subtask yang akan ditracking (nullable)
  /// - description: Deskripsi pekerjaan (optional)
  ///
  /// Returns: Future<TimeLogModel>
  /// Throws: Exception dengan pesan error yang readable
  Future<TimeLogModel> startTimeLog({
    int? cardId,
    int? subtaskId,
    String? description,
  }) async {
    try {
      // Prepare request body
      final requestBody = <String, dynamic>{};
      if (cardId != null) requestBody['card_id'] = cardId;
      if (subtaskId != null) requestBody['subtask_id'] = subtaskId;
      if (description != null && description.isNotEmpty) {
        requestBody['description'] = description;
      }

      // Send POST request
      final response = await dio.post('/v1/time-logs/start', data: requestBody);

      // Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        return TimeLogModel.fromJson(data);
      } else {
        throw Exception(
          'Gagal memulai time log: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio errors dengan pesan yang readable
      if (e.response != null) {
        final message =
            e.response?.data['message'] as String? ??
            e.response?.data['error'] as String? ??
            'Terjadi kesalahan pada server';
        throw Exception('Error ${e.response?.statusCode}: $message');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Periksa koneksi internet Anda.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server tidak merespons. Coba lagi nanti.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Tidak dapat terhubung ke server.');
      } else {
        throw Exception('Terjadi kesalahan: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Menghentikan time log via API
  ///
  /// Endpoint: POST /v1/time-logs/{id}/stop
  /// Request body:
  /// {
  ///   "description": "..."   // optional
  /// }
  ///
  /// Response:
  /// {
  ///   "success": true,
  ///   "message": "Time log stopped successfully",
  ///   "data": {
  ///     "id": 789,
  ///     "card_id": 123,
  ///     "card_title": "Fix bug",
  ///     "board_name": "Development",
  ///     "subtask_id": null,
  ///     "subtask_name": null,
  ///     "start_time": "2024-01-20T10:00:00Z",
  ///     "end_time": "2024-01-20T11:30:00Z",
  ///     "description": "Bug fixed successfully",
  ///     "duration_minutes": 90,
  ///     "duration_formatted": "1h 30m"
  ///   }
  /// }
  ///
  /// Parameter:
  /// - timeLogId: ID time log yang akan dihentikan (required)
  /// - description: Deskripsi hasil pekerjaan (optional)
  ///
  /// Returns: Future<TimeLogModel>
  /// Throws: Exception dengan pesan error yang readable
  Future<TimeLogModel> stopTimeLog(int timeLogId, {String? description}) async {
    try {
      // Prepare request body
      final requestBody = <String, dynamic>{};
      if (description != null && description.isNotEmpty) {
        requestBody['description'] = description;
      }

      // Send POST request
      final response = await dio.post(
        '/v1/time-logs/$timeLogId/stop',
        data: requestBody,
      );

      // Parse response
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return TimeLogModel.fromJson(data);
      } else {
        throw Exception(
          'Gagal menghentikan time log: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio errors dengan pesan yang readable
      if (e.response != null) {
        final message =
            e.response?.data['message'] as String? ??
            e.response?.data['error'] as String? ??
            'Terjadi kesalahan pada server';
        throw Exception('Error ${e.response?.statusCode}: $message');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Periksa koneksi internet Anda.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server tidak merespons. Coba lagi nanti.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Tidak dapat terhubung ke server.');
      } else {
        throw Exception('Terjadi kesalahan: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}
