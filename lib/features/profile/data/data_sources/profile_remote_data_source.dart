import 'package:dio/dio.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';



/// Interface untuk remote data source profil pengguna
/// 
/// Abstraksi ini memisahkan implementasi konkret dari logic bisnis
/// sehingga memudahkan testing dan maintenance
abstract class ProfileRemoteDataSource {
  
  
  
  /// Mengambil data profil pengguna dari API endpoint /api/v1/me
  /// 
  /// Returns Map dengan key 'profile' dan 'stats' yang berisi data profil
  /// Throws DioException jika terjadi error saat request
  Future<Map<String, dynamic>> fetchUserProfile();
  
  
  
  
  /// Melakukan logout pengguna melalui API endpoint /api/v1/logout
  /// 
  /// Returns Map berisi response message dari server
  /// Throws DioException jika terjadi error saat request
  Future<Map<String, dynamic>> logout();
  
  
  
  
  /// Mengupdate profil pengguna melalui API endpoint PUT /api/v1/profile
  /// 
  /// [username] Username baru (optional)
  /// [fullName] Full name baru (optional)
  /// [password] Password baru (optional, min 6 karakter)
  /// 
  /// Returns Map berisi data profil yang sudah diupdate
  /// Throws DioException jika terjadi error saat request
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? fullName,
    String? password,
  });
}
