import 'package:flutter/material.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';



/// Widget untuk menampilkan kartu statistik profil
/// 
/// Berisi 4 statistik utama: Created Projects, Memberships, Created Cards, dan Comments
/// Dengan desain card yang clean dan interaktif
class ProfileStatsWidget extends StatelessWidget {
  final UserProfileModel profile;
  final ProfileStatsModel stats;
  final Function(String) onStatTap;



  /// Constructor dengan parameter profile, stats, dan callback
  /// 
  /// [profile] Data profil pengguna
  /// [stats] Data statistik pengguna
  /// [onStatTap] Callback ketika salah satu stat card di-tap
  const ProfileStatsWidget({
    Key? key,
    required this.profile,
    required this.stats,
    required this.onStatTap,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 18.0 : (screenWidth < 600 ? 20.0 : 22.0);
    
    return Container(
      width: double.infinity, // Full width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Stats',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: screenWidth < 360 ? 12 : 16),
          
          // Row pertama: Created Projects & Memberships
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Projects Created',
                  profile.createdProjects.length.toString(),
                  Icons.folder_outlined,
                  Color(0xFF48BB78),
                  () => onStatTap('created_projects'),
                ),
              ),
              SizedBox(width: screenWidth < 360 ? 8 : 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Projects Folowed',
                  profile.projectMemberships.length.toString(),
                  Icons.groups_outlined,
                  Color(0xFF667EEA),
                  () => onStatTap('memberships'),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth < 360 ? 8 : 12),
          
          // Row kedua: Created Cards & Comments
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Cards Created',
                  profile.createdCards.length.toString(),
                  Icons.task_alt,
                  Color(0xFF9F7AEA),
                  () => onStatTap('created_cards'),
                ),
              ),
              SizedBox(width: screenWidth < 360 ? 8 : 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Comments',
                  stats.totalComments.toString(),
                  Icons.comment_outlined,
                  Color(0xFFED8936),
                  () => onStatTap('comments'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  /// Build individual stat card
  /// 
  /// [context] BuildContext untuk responsive sizing
  /// [title] Judul statistik
  /// [value] Nilai statistik
  /// [icon] Icon yang ditampilkan
  /// [color] Warna tema card
  /// [onTap] Callback ketika card di-tap
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth < 360 ? 12.0 : (screenWidth < 600 ? 16.0 : 20.0);
    final iconSize = screenWidth < 360 ? 24.0 : 28.0;
    final iconPadding = screenWidth < 360 ? 8.0 : 12.0;
    final valueFontSize = screenWidth < 360 ? 22.0 : (screenWidth < 600 ? 24.0 : 28.0);
    final titleFontSize = screenWidth < 360 ? 11.0 : 13.0;
    
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      shadowColor: color.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent overflow
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(height: screenWidth < 360 ? 8 : 12),
              
              // Value text
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              
              // Title text
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
