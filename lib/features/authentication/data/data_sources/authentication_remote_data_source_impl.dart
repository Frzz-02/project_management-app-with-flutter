import 'package:dio/dio.dart';

import 'authentication_remote_data_source.dart';

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final Dio dio;
  AuthenticationRemoteDataSourceImpl(this.dio);

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      // Cek response berhasil (200-29)
      // Penjelasan bayi: Kita cek apakah server bilang "oke" (status 200-299)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Cek struktur response data
        // Penjelasan bayi: Kita cek apakah server kasih token yang kita mau
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;

          // Coba beberapa kemungkinan struktur response
          // Penjelasan bayi: Server bisa kasih token dengan nama yang beda-beda
          if (data.containsKey('token')) {
            return data['token'].toString();
          } else if (data.containsKey('access_token')) {
            return data['access_token'].toString();
          } else if (data.containsKey('data') && data['data'] != null) {
            if (data['data'] is Map &&
                (data['data'] as Map).containsKey('token')) {
              return (data['data'] as Map)['token'].toString();
            } else if (data['data'] is String) {
              return data['data'].toString();
            }
          }
        }

        // Kalau gak ada token, throw error
        // Penjelasan bayi: Kalau server gak kasih token, berarti ada yang salah
        throw Exception(
          'Token tidak ditemukan dalam response: ${response.data}',
        );
      } else {
        throw Exception('Login gagal dengan status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors dengan pesan yang lebih jelas
      // Penjelasan bayi: Kalau ada masalah koneksi, kita kasih pesan yang mudah dimengerti
      if (e.response != null) {
        // Ada response dari server tapi error (401, 422, 500, dll)
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        if (statusCode == 401) {
          throw Exception('Email atau password salah');
        } else if (statusCode == 422) {
          // Validation error, coba ambil pesan dari server
          if (responseData is Map && responseData.containsKey('message')) {
            throw Exception(responseData['message']);
          } else {
            throw Exception('Data yang dimasukkan tidak valid');
          }
        } else if (statusCode == 500) {
          throw Exception('Server sedang bermasalah, coba lagi nanti');
        } else {
          throw Exception('Login gagal: ${responseData ?? 'Unknown error'}');
        }
      } else {
        // Tidak ada response (connection error, timeout, dll)
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception('Koneksi timeout, server terlalu lambat');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('Tidak bisa terhubung ke server');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Server terlalu lambat merespon');
        } else {
          throw Exception('Masalah jaringan: ${e.message}');
        }
      }
    } catch (e) {
      // Handle error lainnya
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}
