



/// Interface repository untuk operasi profil pengguna
/// 
/// Abstraksi ini memungkinkan implementasi yang berbeda (mock, real, cache)
/// tanpa mengubah business logic di use case atau cubit
abstract class ProfileRepository {
  
  
  
  /// Mengambil data profil pengguna
  /// 
  /// Returns Map dengan key 'profile' dan 'stats'
  /// Throws Exception jika terjadi error
  Future<Map<String, dynamic>> fetchUserProfile();
  
  
  
  
  /// Melakukan logout pengguna
  /// 
  /// Returns Map dengan response message
  /// Throws Exception jika terjadi error
  Future<Map<String, dynamic>> logout();
  
  
  
  
  /// Mengupdate profil pengguna
  /// 
  /// [username] Username baru (optional)
  /// [fullName] Full name baru (optional)
  /// [password] Password baru (optional)
  /// 
  /// Returns Map dengan data profil yang sudah diupdate
  /// Throws Exception jika terjadi error
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? fullName,
    String? password,
  });
}
