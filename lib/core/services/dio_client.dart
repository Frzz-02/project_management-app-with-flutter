import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_management/core/services/auth_interceptor.dart';
import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source.dart';

/// DioClient - Service untuk konfigurasi Dio instance
/// Mengelola base URL, timeout, headers, dan interceptors
///
/// Penjelasan bayi: Ini kayak tukang bikin alat buat ngomong sama server
/// dengan aturan yang jelas dan lengkap
class DioClient {
  late final Dio dio;

  DioClient({
    required String baseUrl,
    required AuthLocalDataSource localDataSource,
    VoidCallback? onTokenExpired,
  }) {
    // Setup Dio dengan konfigurasi yang lebih lengkap
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10), // Timeout koneksi 10 detik
        receiveTimeout: const Duration(
          seconds: 10,
        ), // Timeout terima data 10 detik
        sendTimeout: const Duration(seconds: 10), // Timeout kirim data 10 detik
        headers: {
          'Content-Type':
              'application/json', // Kasih tau server kita kirim JSON
          'Accept': 'application/json', // Kasih tau server kita mau terima JSON
        },
      ),
    );

    // Tambahkan interceptor untuk otomatis nambahin Bearer token
    // Penjelasan bayi: Ini kayak bodyguard yang otomatis kasih kartu identitas ke server
    dio.interceptors.add(
      AuthInterceptor(
        localDataSource: localDataSource,
        onTokenExpired: onTokenExpired,
      ),
    );

    // Tambahkan interceptor untuk debugging
    // Penjelasan bayi: Ini kayak mata-mata yang liat semua percakapan sama server
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) =>
            print('🌐 DIO: $object'), // Print dengan emoji biar gampang diliat
      ),
    );
  }

  /// Get Dio instance
  Dio get instance => dio;
}
