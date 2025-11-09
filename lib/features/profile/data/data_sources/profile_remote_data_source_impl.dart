import 'package:dio/dio.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';
import 'profile_remote_data_source.dart';



/// Implementasi konkret dari ProfileRemoteDataSource
/// 
/// Class ini menggunakan Dio untuk melakukan HTTP request ke backend API
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;



  /// Constructor dengan dependency injection Dio client
  /// 
  /// [dio] Instance Dio yang sudah dikonfigurasi dengan interceptor dan base URL
  ProfileRemoteDataSourceImpl({required this.dio});



  /// Implementasi fetch user profile dari API
  /// 
  /// Endpoint: GET /api/v1/me
  /// Returns Map dengan structure:
  /// {
  ///   'profile': UserProfileModel,
  ///   'stats': ProfileStatsModel
  /// }
  @override
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      print('[ProfileRemoteDataSource] Fetching user profile from /v1/me');
      
      final response = await dio.get('/v1/me');
      
      print('[ProfileRemoteDataSource] Profile fetch successful');
      print('[ProfileRemoteDataSource] Response data: ${response.data}');

      if (response.data['success'] == true) {
        final profileData = UserProfileModel.fromJson(response.data['data']);
        final statsData = ProfileStatsModel.fromJson(response.data['stats']);

        return {
          'profile': profileData,
          'stats': statsData,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API returned success: false',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('[ProfileRemoteDataSource] DioException: ${e.message}');
      print('[ProfileRemoteDataSource] Error type: ${e.type}');
      print('[ProfileRemoteDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('[ProfileRemoteDataSource] Unexpected error: $e');
      rethrow;
    }
  }



  /// Implementasi logout dari API
  /// 
  /// Endpoint: POST /api/v1/logout
  /// Returns Map dengan message dari server
  @override
  Future<Map<String, dynamic>> logout() async {
    try {
      print('[ProfileRemoteDataSource] Logging out via /v1/logout');
      
      final response = await dio.post('/v1/logout');
      
      print('[ProfileRemoteDataSource] Logout successful');
      print('[ProfileRemoteDataSource] Response: ${response.data}');
      print('[ProfileRemoteDataSource] Response type: ${response.data.runtimeType}');

      // Handle response yang mungkin null atau bukan Map
      if (response.data == null) {
        return {'message': 'Logged out successfully'};
      }
      
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      
      // If response is just a string or other type
      return {'message': response.data.toString()};
    } on DioException catch (e) {
      print('[ProfileRemoteDataSource] Logout DioException: ${e.message}');
      print('[ProfileRemoteDataSource] Error type: ${e.type}');
      print('[ProfileRemoteDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('[ProfileRemoteDataSource] Logout unexpected error: $e');
      rethrow;
    }
  }
  
  
  
  
  /// Implementasi update profile dari API
  /// 
  /// Endpoint: PUT /v1/profile
  /// Request Body: { username?, full_name?, password? }
  /// Returns Map dengan data profil yang sudah diupdate
  @override
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? fullName,
    String? password,
  }) async {
    try {
      print('[ProfileRemoteDataSource] Updating profile via /v1/profile');
      
      // Build request body hanya dengan field yang diisi
      final Map<String, dynamic> requestBody = {};
      if (username != null && username.isNotEmpty) {
        requestBody['username'] = username;
      }
      if (fullName != null && fullName.isNotEmpty) {
        requestBody['full_name'] = fullName;
      }
      if (password != null && password.isNotEmpty) {
        requestBody['password'] = password;
      }
      
      print('[ProfileRemoteDataSource] Request body: $requestBody');
      
      final response = await dio.put('/v1/profile', data: requestBody);
      
      print('[ProfileRemoteDataSource] Profile update successful');
      print('[ProfileRemoteDataSource] Response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API returned success: false',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('[ProfileRemoteDataSource] Update DioException: ${e.message}');
      print('[ProfileRemoteDataSource] Error type: ${e.type}');
      print('[ProfileRemoteDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('[ProfileRemoteDataSource] Update unexpected error: $e');
      rethrow;
    }
  }
}
