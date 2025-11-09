import 'package:flutter/material.dart';



/// Widget untuk menampilkan section settings dan logout
/// 
/// Berisi opsi-opsi pengaturan akun dan tombol logout
/// dengan desain yang clean dan user-friendly
class ProfileSettingsWidget extends StatelessWidget {
  final bool notificationsEnabled;
  final Function(bool) onNotificationToggle;
  final Function(String) onSettingTap;
  final VoidCallback onLogoutTap;



  /// Constructor dengan parameter callbacks
  /// 
  /// [notificationsEnabled] Status notifikasi (on/off)
  /// [onNotificationToggle] Callback ketika toggle notifikasi diubah
  /// [onSettingTap] Callback ketika salah satu setting item di-tap
  /// [onLogoutTap] Callback ketika tombol logout di-tap
  const ProfileSettingsWidget({
    Key? key,
    required this.notificationsEnabled,
    required this.onNotificationToggle,
    required this.onSettingTap,
    required this.onLogoutTap,
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
            'Settings',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: screenWidth < 360 ? 12 : 16),
          
          // Settings items card
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.notifications_active,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    hasToggle: true,
                    action: () {},
                    isLast: false,
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your account security',
                    hasToggle: false,
                    action: () => onSettingTap('privacy'),
                    isLast: false,
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    hasToggle: false,
                    action: () => onSettingTap('help'),
                    isLast: false,
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    hasToggle: false,
                    action: () => onSettingTap('about'),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenWidth < 360 ? 16 : 24),
          
          // Logout button
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Color(0xFFE53E3E).withOpacity(0.2),
            child: InkWell(
              onTap: onLogoutTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth < 360 ? 14 : 18,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE53E3E), Color(0xFFC53030)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: screenWidth < 360 ? 18 : 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 14.0 : 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  /// Build individual setting item
  /// 
  /// [context] BuildContext untuk responsive sizing
  /// [icon] Icon untuk setting
  /// [title] Judul setting
  /// [subtitle] Deskripsi setting
  /// [hasToggle] Apakah item memiliki toggle switch
  /// [action] Callback ketika item di-tap
  /// [isLast] Apakah ini item terakhir (untuk border)
  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasToggle,
    required VoidCallback action,
    required bool isLast,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 20.0;
    final verticalPadding = screenWidth < 360 ? 12.0 : 16.0;
    final iconSize = screenWidth < 360 ? 18.0 : 20.0;
    final titleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final subtitleFontSize = screenWidth < 360 ? 11.0 : 13.0;
    
    return InkWell(
      onTap: hasToggle ? null : action,
      borderRadius: BorderRadius.circular(isLast ? 16 : 0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: !isLast
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              )
            : null,
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(screenWidth < 360 ? 6 : 8),
              decoration: BoxDecoration(
                color: Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF667EEA), size: iconSize),
            ),
            SizedBox(width: screenWidth < 360 ? 12 : 16),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Color(0xFF2D3748),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Color(0xFF718096),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Toggle or arrow
            hasToggle
                ? Switch(
                    value: notificationsEnabled,
                    onChanged: onNotificationToggle,
                    activeColor: Color(0xFF667EEA),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFCBD5E0),
                    size: screenWidth < 360 ? 14 : 16,
                  ),
          ],
        ),
      ),
    );
  }
}
