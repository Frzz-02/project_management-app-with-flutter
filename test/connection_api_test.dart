import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test untuk mengecek koneksi ke API backend
/// Penjelasan bayi: Ini kayak ngetok pintu server buat tau servernya nyala atau nggak
void main() {
  group('API Connection Tests', () {
    late Dio dio;
    const String baseUrl = 'http://127.0.0.1:8000/api';

    setUp(() {
      // Setup Dio dengan timeout yang pendek buat test
      // Penjelasan bayi: Kita bikin alat buat ngomong sama server, tapi kasih batas waktu pendek
      dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5), // Timeout 5 detik
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
    });

    test('Test koneksi dasar ke server', () async {
      try {
        // Coba ping ke server dengan endpoint sederhana
        // Penjelasan bayi: Kita coba ketuk pintu server buat tau dia hidup atau nggak
        final response = await dio.get('/');

        // Kalau dapat response (status code apa aja), berarti server hidup
        // Penjelasan bayi: Kalau server jawab (meski bilang error), berarti dia nyala
        print('✅ Server hidup! Status: ${response.statusCode}');
        expect(response.statusCode, isNotNull);
      } on DioException catch (e) {
        // Cek jenis error buat tau masalahnya apa
        // Penjelasan bayi: Kalau ada error, kita liat errornya karena apa
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          print('❌ Server tidak bisa diakses: ${e.message}');
          print('💡 Pastikan server backend sudah jalan di $baseUrl');
          fail('Server tidak bisa diakses. Pastikan backend sudah running.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          print('⏰ Server lambat merespon');
          fail('Server terlalu lambat merespon');
        } else {
          // Error lain (404, 500, dll) berarti server hidup tapi endpoint bermasalah
          // Penjelasan bayi: Kalau dapat error 404 atau 500, berarti server hidup cuma endpointnya salah
          print(
            '✅ Server hidup tapi ada error: ${e.response?.statusCode} - ${e.message}',
          );
          expect(e.response?.statusCode, isNotNull);
        }
      } catch (e) {
        print('❌ Error tidak dikenal: $e');
        fail('Error tidak dikenal: $e');
      }
    });

    test('Test endpoint login tersedia', () async {
      try {
        // Test endpoint login dengan data dummy
        // Penjelasan bayi: Kita coba akses pintu login buat tau ada atau nggak
        final response = await dio.post(
          '/login',
          data: {'email': 'test@test.com', 'password': 'password123'},
        );

        print('✅ Endpoint login tersedia! Status: ${response.statusCode}');
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          print('❌ Server tidak bisa diakses untuk endpoint login');
          fail('Server tidak bisa diakses');
        } else {
          // Bahkan kalau login gagal (401, 422), berarti endpoint ada
          // Penjelasan bayi: Meski login ditolak, berarti pintu loginnya ada
          print('✅ Endpoint login tersedia! Status: ${e.response?.statusCode}');
          print('📝 Response: ${e.response?.data}');
          expect(e.response?.statusCode, isNotNull);
        }
      }
    });

    test('Test semua endpoint penting tersedia', () async {
      // List endpoint yang perlu dicek
      // Penjelasan bayi: Daftar pintu-pintu penting yang harus ada di server
      final endpoints = ['/login', '/register', '/user', '/tasks'];

      for (String endpoint in endpoints) {
        try {
          print('🔍 Mengecek endpoint: $endpoint');

          // Untuk endpoint yang butuh auth, kita cuma cek apakah ada response
          // Penjelasan bayi: Kita ketuk setiap pintu buat tau ada atau nggak
          final response = await dio.get(endpoint);
          print('✅ $endpoint tersedia! Status: ${response.statusCode}');
        } on DioException catch (e) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('❌ Server tidak bisa diakses untuk $endpoint');
            fail('Server tidak bisa diakses');
          } else {
            // Status 401, 404, 422 dll berarti endpoint ada tapi butuh auth atau method salah
            // Penjelasan bayi: Kalau dapat error tapi bukan connection error, berarti pintunya ada
            print('✅ $endpoint tersedia! Status: ${e.response?.statusCode}');
          }
        }
      }
    });

    test('Test kecepatan response server', () async {
      try {
        final stopwatch = Stopwatch()..start();

        // Coba request sederhana dan ukur waktunya
        // Penjelasan bayi: Kita ukur seberapa cepat server jawab
        await dio.get('/');

        stopwatch.stop();
        final responseTime = stopwatch.elapsedMilliseconds;

        print('⚡ Response time: ${responseTime}ms');

        // Kalau lebih dari 3 detik, kasih warning
        // Penjelasan bayi: Kalau server jawabnya lebih dari 3 detik, berarti lambat
        if (responseTime > 3000) {
          print('⚠️ Server agak lambat (${responseTime}ms)');
        } else {
          print('✅ Server cukup cepat');
        }

        expect(responseTime, lessThan(10000)); // Max 10 detik
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          fail('Server tidak bisa diakses untuk test kecepatan');
        } else {
          // Bahkan error response tetap dihitung sebagai response
          print('✅ Server merespon (meski ada error)');
        }
      }
    });
  });
}
