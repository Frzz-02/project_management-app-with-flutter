import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source.dart';

/// AuthInterceptor - Interceptor untuk otomatis menambahkan Bearer token ke setiap request
/// Dan handle error 401 (Unauthorized) untuk redirect ke login
///
/// Penjelasan bayi: Ini kayak bodyguard yang otomatis kasih kartu identitas ke server
/// dan kalau kartu identitasnya expired, dia akan hapus kartu lama
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  // Callback untuk handle logout ketika token expired
  // Kita pakai callback karena interceptor tidak punya akses ke BuildContext
  final VoidCallback? onTokenExpired;

  AuthInterceptor({required this.localDataSource, this.onTokenExpired});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ambil token dari secure storage
    final token = await localDataSource.getCacheToken();

    if (token != null && token.isNotEmpty) {
      // Tambahin Bearer token ke header
      options.headers['Authorization'] = 'Bearer $token';
      print(
        '🔐 Token ditambahkan ke request: Bearer ${token.substring(0, 10)}...',
      );
    }

    // Lanjutkan request
    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    // Kalau dapat error 401 (Unauthorized), berarti token expired
    if (error.response?.statusCode == 401) {
      print('🚫 Token expired atau invalid, menghapus token...');

      // Hapus token yang expired
      await localDataSource.clearToken();

      // Panggil callback untuk handle logout/redirect
      // Redirect akan dihandle oleh GoRouter redirect logic di app_router.dart
      onTokenExpired?.call();
    }

    // Lanjutkan error ke handler berikutnya
    handler.next(error);
  }
}
