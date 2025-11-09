import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';
import 'package:project_management/features/profile/domain/repositories/profile_repository.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_state.dart';



/// Cubit untuk mengelola state dan business logic halaman profil
/// 
/// Menggunakan BLoC pattern untuk memisahkan UI dan business logic
/// Menangani fetch profil dan logout functionality
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final AuthLocalDataSource localDataSource;



  /// Constructor dengan dependency injection repository dan localDataSource
  /// 
  /// [repository] Repository untuk mengakses data profil
  /// [localDataSource] Local data source untuk clear token saat logout
  /// Initial state adalah ProfileInitial
  ProfileCubit({
    required this.repository,
    required this.localDataSource,
  }) : super(ProfileInitial());



  /// Mengambil data profil pengguna dari API
  /// 
  /// Emit ProfileLoading sebelum request
  /// Emit ProfileLoaded jika sukses dengan data profil dan stats
  /// Emit ProfileError jika terjadi error dengan pesan error
  Future<void> fetchProfile() async {
    try {
      print('[ProfileCubit] Fetching profile...');
      emit(ProfileLoading());

      final result = await repository.fetchUserProfile();
      
      print('[ProfileCubit] Profile fetched successfully');
      emit(ProfileLoaded(
        profile: result['profile'],
        stats: result['stats'],
      ));
    } catch (e) {
      print('[ProfileCubit] Error fetching profile: $e');
      emit(ProfileError(
        message: 'Failed to load profile: ${e.toString()}',
      ));
    }
  }



  /// Melakukan logout pengguna
  /// 
  /// Emit ProfileLoggingOut sebelum request logout
  /// Emit ProfileLoggedOut jika sukses dengan message dari server
  /// Emit ProfileLogoutError jika terjadi error
  /// 
  /// PENTING: Token akan dihapus dari local storage bahkan jika API call gagal
  /// karena yang penting adalah user keluar dari aplikasi
  Future<void> logout() async {
    try {
      print('[ProfileCubit] Logging out...');
      emit(ProfileLoggingOut());

      try {
        // Try to call logout API
        final result = await repository.logout();
        print('[ProfileCubit] Logout API successful');
        print('[ProfileCubit] Response: $result');
        
        // Clear token from local storage
        await localDataSource.clearToken();
        print('[ProfileCubit] Token cleared from storage');
        
        // Get message from response
        final message = result['message'] ?? result['data']?['message'] ?? 'Logged out successfully';
        
        emit(ProfileLoggedOut(message: message));
      } catch (apiError) {
        // Even if API fails, still clear token and logout user
        print('[ProfileCubit] Logout API error: $apiError');
        print('[ProfileCubit] Clearing token anyway for security...');
        
        await localDataSource.clearToken();
        print('[ProfileCubit] Token cleared from storage');
        
        // Still emit success state because user is logged out locally
        emit(ProfileLoggedOut(
          message: 'Logged out successfully',
        ));
      }
    } catch (e) {
      print('[ProfileCubit] Critical error during logout: $e');
      
      // Try to clear token even in worst case
      try {
        await localDataSource.clearToken();
        print('[ProfileCubit] Token cleared from storage (fallback)');
        emit(ProfileLoggedOut(
          message: 'Logged out successfully',
        ));
      } catch (clearError) {
        print('[ProfileCubit] Failed to clear token: $clearError');
        emit(ProfileLogoutError(
          message: 'Failed to logout completely. Please try again.',
        ));
      }
    }
  }
  
  
  
  
  /// Mengupdate profil pengguna
  /// 
  /// [username] Username baru (optional)
  /// [fullName] Full name baru (optional)
  /// [password] Password baru (optional)
  /// 
  /// Emit ProfileUpdating sebelum request update
  /// Emit ProfileUpdated jika sukses dengan message dan data baru
  /// Emit ProfileUpdateError jika terjadi error
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? password,
  }) async {
    try {
      print('[ProfileCubit] Updating profile...');
      emit(ProfileUpdating());

      final result = await repository.updateProfile(
        username: username,
        fullName: fullName,
        password: password,
      );
      
      print('[ProfileCubit] Profile updated successfully');
      
      // Parse updated profile data from response JSON ke UserProfileModel
      final updatedProfileData = result['data'] as Map<String, dynamic>;
      final updatedProfile = UserProfileModel.fromJson(updatedProfileData);
      
      emit(ProfileUpdated(
        message: result['message'] ?? 'Profile updated successfully',
        profile: updatedProfile,
      ));
      
      // After success, refresh the profile to get complete data
      await fetchProfile();
    } catch (e) {
      print('[ProfileCubit] Error updating profile: $e');
      emit(ProfileUpdateError(
        message: 'Failed to update profile: ${e.toString()}',
      ));
    }
  }
}
