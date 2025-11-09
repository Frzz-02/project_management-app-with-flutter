import 'package:flutter/material.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';



/// Widget untuk menampilkan header profil pengguna
/// 
/// Berisi foto profil, nama lengkap, role, dan email pengguna
/// Dengan desain gradient dan shadow yang modern
class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileModel profile;
  final VoidCallback onEditPhoto;



  /// Constructor dengan parameter profil dan callback edit foto
  /// 
  /// [profile] Data profil pengguna yang akan ditampilkan
  /// [onEditPhoto] Callback ketika user tap pada foto profil
  const ProfileHeaderWidget({
    Key? key,
    required this.profile,
    required this.onEditPhoto,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // Get screen width untuk responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Padding yang responsive berdasarkan lebar layar
    final horizontalPadding = screenWidth < 360 ? 12.0 : (screenWidth < 600 ? 16.0 : 24.0);
    final verticalPadding = screenWidth < 360 ? 16.0 : 24.0;
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.black12,
      child: Container(
        width: double.infinity, // Full width
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF7FAFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            _buildProfilePhoto(screenWidth),
            SizedBox(height: screenWidth < 360 ? 16 : 20),
            _buildUserName(screenWidth),
            SizedBox(height: 6),
            _buildRoleBadge(screenWidth),
            SizedBox(height: 12),
            _buildUserEmail(screenWidth),
          ],
        ),
      ),
    );
  }



  /// Build widget foto profil dengan tombol edit
  /// 
  /// Menampilkan inisial jika tidak ada foto atau foto error
  /// [screenWidth] Lebar layar untuk responsive sizing
  Widget _buildProfilePhoto(double screenWidth) {
    // Responsive avatar size
    final avatarSize = screenWidth < 360 ? 90.0 : (screenWidth < 600 ? 100.0 : 110.0);
    final avatarRadius = (avatarSize - 8) / 2;
    final fontSize = screenWidth < 360 ? 28.0 : (screenWidth < 600 ? 30.0 : 32.0);
    
    return GestureDetector(
      onTap: onEditPhoto,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient untuk foto
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          ),
          
          // Avatar dengan inisial atau foto
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Color(0xFF667EEA),
            child: Text(
              _getInitials(profile.fullName),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          // Icon camera untuk edit foto
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: EdgeInsets.all(screenWidth < 360 ? 4 : 6),
              decoration: BoxDecoration(
                color: Color(0xFF48BB78),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: screenWidth < 360 ? 14 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }



  /// Build widget nama pengguna
  /// 
  /// [screenWidth] Lebar layar untuk responsive sizing
  Widget _buildUserName(double screenWidth) {
    final fontSize = screenWidth < 360 ? 20.0 : (screenWidth < 600 ? 24.0 : 26.0);
    
    return Text(
      profile.fullName,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
      textAlign: TextAlign.center,
      maxLines: 2, // Prevent overflow
      overflow: TextOverflow.ellipsis,
    );
  }



  /// Build widget badge role pengguna
  /// 
  /// [screenWidth] Lebar layar untuk responsive sizing
  Widget _buildRoleBadge(double screenWidth) {
    final fontSize = screenWidth < 360 ? 12.0 : 14.0;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _formatRole(profile.role),
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }



  /// Build widget email pengguna
  /// 
  /// [screenWidth] Lebar layar untuk responsive sizing
  Widget _buildUserEmail(double screenWidth) {
    final fontSize = screenWidth < 360 ? 13.0 : (screenWidth < 600 ? 14.0 : 16.0);
    
    return Text(
      profile.email,
      style: TextStyle(
        fontSize: fontSize,
        color: Color(0xFF718096),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      maxLines: 1, // Prevent overflow
      overflow: TextOverflow.ellipsis,
    );
  }



  /// Helper untuk mendapatkan inisial dari nama lengkap
  /// 
  /// [fullName] Nama lengkap pengguna
  /// Returns String 2 karakter inisial
  String _getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }



  /// Helper untuk format role menjadi lebih readable
  /// 
  /// [role] Role dari API (member, admin, etc)
  /// Returns String role yang sudah diformat
  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'member':
        return 'Team Member';
      case 'developer':
        return 'Developer';
      case 'manager':
        return 'Project Manager';
      default:
        return role[0].toUpperCase() + role.substring(1);
    }
  }
}
