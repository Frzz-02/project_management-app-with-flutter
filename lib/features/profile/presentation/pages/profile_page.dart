import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/authentication/presentation/pages/login_page.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_state.dart';
import 'package:project_management/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:project_management/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:project_management/features/profile/presentation/widgets/profile_stats_widget.dart';
import 'package:project_management/features/profile/presentation/widgets/recent_work_widget.dart';
import 'package:project_management/features/profile/presentation/widgets/profile_settings_widget.dart';



/// ProfilePage adalah halaman profil pengguna yang menampilkan informasi pribadi,
/// statistik kinerja, pekerjaan terkini, dan pengaturan akun.
/// 
/// Halaman ini menggunakan BLoC pattern dengan ProfileCubit untuk state management
/// dan mengambil data real dari API endpoint /api/v1/me
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);



  /// Route name untuk navigasi ke halaman profil
  static const String routeName = '/profile';



  @override
  State<ProfilePage> createState() => _ProfilePageState();
}




/// State class untuk ProfilePage yang mengelola animasi dan interaksi pengguna
class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  /// Controller untuk mengatur animasi fade-in halaman
  late AnimationController _animationController;

  /// Animasi fade untuk transisi masuk halaman
  late Animation<double> _fadeAnimation;

  /// Status notifikasi (aktif/nonaktif)
  bool _notificationsEnabled = true;



  /// Inisialisasi state dan setup animasi fade-in
  @override
  void initState() {
    super.initState();
    
    // Setup animation controller dengan durasi 1 detik
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Buat animasi fade dari 0.0 ke 1.0 dengan kurva easeInOut
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Mulai animasi
    _animationController.forward();
    
    // Fetch profile data saat halaman dimuat
    context.read<ProfileCubit>().fetchProfile();
  }



  /// Cleanup resources saat widget di-dispose
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  /// Menampilkan dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Color(0xFFE53E3E)),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(color: Color(0xFF4A5568)),
          ),
          actions: [
            // Tombol cancel
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF718096))),
            ),
            
            // Tombol logout
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Call logout dari cubit
                context.read<ProfileCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE53E3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }



  /// Build method utama yang mengembalikan struktur UI halaman profil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // Handle logout success
          if (state is ProfileLoggedOut) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color(0xFF48BB78),
              ),
            );
            
            // Navigate to login page dan clear navigation stack
            // Use rootNavigator to escape nested navigators
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
          
          // Handle logout error
          if (state is ProfileLogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color(0xFFE53E3E),
              ),
            );
          }
        },
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                
                // Content based on state
                if (state is ProfileLoading || state is ProfileLoggingOut)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF667EEA),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            state is ProfileLoggingOut 
                                ? 'Logging out...' 
                                : 'Loading profile...',
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is ProfileError)
                  SliverFillRemaining(
                    child: _buildErrorState(state.message),
                  )
                else if (state is ProfileLoaded)
                  SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive padding berdasarkan lebar layar
                        final screenWidth = constraints.maxWidth;
                        final padding = screenWidth < 360 ? 12.0 : (screenWidth < 600 ? 16.0 : 20.0);
                        
                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center all content
                            children: [
                              // Profile Header - Full width centered
                              ProfileHeaderWidget(
                                profile: state.profile,
                                onEditPhoto: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Change profile picture'),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenWidth < 360 ? 16 : 24),
                              
                              // Stats Section
                              ProfileStatsWidget(
                                profile: state.profile,
                                stats: state.stats,
                                onStatTap: (String statType) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Navigating to $statType...'),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenWidth < 360 ? 16 : 24),
                              
                              // Recent Work Section
                              RecentWorkWidget(
                                cards: state.profile.createdCards,
                                onCardTap: (card) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Opening ${card.cardTitle}...'),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenWidth < 360 ? 16 : 24),
                              
                              // Settings Section
                              ProfileSettingsWidget(
                                notificationsEnabled: _notificationsEnabled,
                                onNotificationToggle: (value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value
                                            ? 'Notifications enabled'
                                            : 'Notifications disabled',
                                      ),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                                onSettingTap: (String setting) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Navigating to $setting...'),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                                onLogoutTap: _showLogoutDialog,
                              ),
                              SizedBox(height: screenWidth < 360 ? 24 : 32),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No profile data',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }



  /// Membangun SliverAppBar dengan tombol edit dan refresh
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      
      // Tombol back
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.pop(context),
      ),
      
      // Tombol edit dan refresh
      actions: [
        // Button Edit Profile
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            // Only show edit button when profile is loaded
            if (state is ProfileLoaded) {
              return IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF48BB78).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.edit_outlined, color: Color(0xFF48BB78), size: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        currentProfile: state.profile,
                      ),
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
        SizedBox(width: 8),
        
        // Button Refresh
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.refresh, color: Color(0xFF667EEA), size: 20),
          ),
          onPressed: () {
            context.read<ProfileCubit>().fetchProfile();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Refreshing profile...'),
                backgroundColor: Color(0xFF667EEA),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        SizedBox(width: 8),
      ],
      
      // Title
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }



  /// Build error state widget
  /// 
  /// [message] Pesan error yang akan ditampilkan
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Color(0xFFE53E3E),
            ),
            SizedBox(height: 24),
            Text(
              'Error Loading Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProfileCubit>().fetchProfile();
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
