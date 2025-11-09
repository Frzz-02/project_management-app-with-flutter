import 'package:equatable/equatable.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';



/// Base class untuk semua state di ProfileCubit
/// 
/// Menggunakan Equatable untuk memudahkan comparison state
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}




/// State awal ketika profil belum dimuat
/// 
/// Ditampilkan saat pertama kali halaman profil dibuka
class ProfileInitial extends ProfileState {}




/// State ketika sedang mengambil data profil dari API
/// 
/// Digunakan untuk menampilkan loading indicator
class ProfileLoading extends ProfileState {}




/// State ketika data profil berhasil dimuat
/// 
/// Berisi data profil lengkap dan statistik pengguna
class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  final ProfileStatsModel stats;



  ProfileLoaded({
    required this.profile,
    required this.stats,
  });



  @override
  List<Object?> get props => [profile, stats];
}




/// State ketika terjadi error saat mengambil data profil
/// 
/// Berisi pesan error yang dapat ditampilkan ke user
class ProfileError extends ProfileState {
  final String message;



  ProfileError({required this.message});



  @override
  List<Object?> get props => [message];
}




/// State ketika sedang proses logout
/// 
/// Digunakan untuk menampilkan loading saat logout
class ProfileLoggingOut extends ProfileState {}




/// State ketika logout berhasil
/// 
/// Trigger untuk navigasi ke halaman login
class ProfileLoggedOut extends ProfileState {
  final String message;



  ProfileLoggedOut({required this.message});



  @override
  List<Object?> get props => [message];
}




/// State ketika logout gagal
/// 
/// Berisi pesan error logout yang perlu ditampilkan
class ProfileLogoutError extends ProfileState {
  final String message;



  ProfileLogoutError({required this.message});



  @override
  List<Object?> get props => [message];
}




/// State ketika sedang proses update profile
/// 
/// Digunakan untuk menampilkan loading saat update
class ProfileUpdating extends ProfileState {}




/// State ketika update profile berhasil
/// 
/// Berisi pesan success dan data profil yang sudah diupdate
class ProfileUpdated extends ProfileState {
  final String message;
  final UserProfileModel profile;



  ProfileUpdated({
    required this.message,
    required this.profile,
  });



  @override
  List<Object?> get props => [message, profile];
}




/// State ketika update profile gagal
/// 
/// Berisi pesan error yang perlu ditampilkan
class ProfileUpdateError extends ProfileState {
  final String message;



  ProfileUpdateError({required this.message});



  @override
  List<Object?> get props => [message];
}
