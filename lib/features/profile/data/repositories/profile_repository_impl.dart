import 'package:project_management/features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../domain/repositories/profile_repository.dart';



/// Implementasi konkret dari ProfileRepository
/// 
/// Class ini berfungsi sebagai jembatan antara data source dan use case
/// Menerapkan Clean Architecture dengan memisahkan domain dan data layer
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;



  /// Constructor dengan dependency injection
  /// 
  /// [remoteDataSource] Data source untuk mengakses API profil
  ProfileRepositoryImpl({required this.remoteDataSource});



  /// Mengambil data profil pengguna dari remote data source
  /// 
  /// Returns Map dengan data profile dan stats
  /// Throws Exception jika terjadi error
  @override
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      return await remoteDataSource.fetchUserProfile();
    } catch (e) {
      print('[ProfileRepository] Error fetching profile: $e');
      rethrow;
    }
  }



  /// Melakukan logout melalui remote data source
  /// 
  /// Returns Map dengan message dari server
  /// Throws Exception jika terjadi error
  @override
  Future<Map<String, dynamic>> logout() async {
    try {
      return await remoteDataSource.logout();
    } catch (e) {
      print('[ProfileRepository] Error during logout: $e');
      rethrow;
    }
  }
  
  
  
  
  /// Mengupdate profil pengguna melalui remote data source
  /// 
  /// [username] Username baru (optional)
  /// [fullName] Full name baru (optional)
  /// [password] Password baru (optional)
  /// 
  /// Returns Map dengan data profil yang sudah diupdate
  /// Throws Exception jika terjadi error
  @override
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? fullName,
    String? password,
  }) async {
    try {
      return await remoteDataSource.updateProfile(
        username: username,
        fullName: fullName,
        password: password,
      );
    } catch (e) {
      print('[ProfileRepository] Error updating profile: $e');
      rethrow;
    }
  }
}
