import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_state.dart';



/// EditProfilePage adalah halaman untuk mengedit informasi profil pengguna
/// 
/// Halaman ini memungkinkan user untuk mengupdate username, full name, dan password
/// Menggunakan BLoC pattern dengan ProfileCubit untuk state management
class EditProfilePage extends StatefulWidget {
  final UserProfileModel currentProfile;
  
  
  
  /// Route name untuk navigasi ke halaman edit profile
  static const String routeName = '/edit-profile';
  
  
  
  /// Constructor dengan parameter profil saat ini
  /// 
  /// [currentProfile] Data profil user yang sedang login
  const EditProfilePage({
    Key? key,
    required this.currentProfile,
  }) : super(key: key);



  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}




/// State class untuk EditProfilePage
class _EditProfilePageState extends State<EditProfilePage> {
  /// Form key untuk validasi form
  final _formKey = GlobalKey<FormState>();
  
  /// Text controllers untuk input fields
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  
  /// Flag untuk show/hide password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  /// Flag untuk track apakah ada perubahan
  bool _hasChanges = false;



  @override
  void initState() {
    super.initState();
    
    // Initialize controllers dengan data saat ini
    _usernameController = TextEditingController(text: widget.currentProfile.username);
    _fullNameController = TextEditingController(text: widget.currentProfile.fullName);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    
    // Add listeners untuk detect changes
    _usernameController.addListener(_checkForChanges);
    _fullNameController.addListener(_checkForChanges);
    _passwordController.addListener(_checkForChanges);
  }



  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }



  /// Check apakah ada perubahan dari data asli
  void _checkForChanges() {
    final hasUsernameChanged = _usernameController.text != widget.currentProfile.username;
    final hasFullNameChanged = _fullNameController.text != widget.currentProfile.fullName;
    final hasPasswordEntered = _passwordController.text.isNotEmpty;
    
    setState(() {
      _hasChanges = hasUsernameChanged || hasFullNameChanged || hasPasswordEntered;
    });
  }



  /// Handle submit form
  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No changes detected'),
          backgroundColor: Color(0xFFED8936),
        ),
      );
      return;
    }
    
    // Get values yang akan diupdate
    final username = _usernameController.text != widget.currentProfile.username
        ? _usernameController.text
        : null;
    final fullName = _fullNameController.text != widget.currentProfile.fullName
        ? _fullNameController.text
        : null;
    final password = _passwordController.text.isNotEmpty
        ? _passwordController.text
        : null;
    
    // Call cubit untuk update
    context.read<ProfileCubit>().updateProfile(
      username: username,
      fullName: fullName,
      password: password,
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 360 ? 16.0 : (screenWidth < 600 ? 20.0 : 24.0);
    
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color(0xFF48BB78),
              ),
            );
            // Pop back to profile page
            Navigator.pop(context);
          }
          
          if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color(0xFFE53E3E),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;
          
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(padding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header Info
                  _buildProfileHeader(),
                  SizedBox(height: screenWidth < 360 ? 24 : 32),
                  
                  // Username Field
                  _buildInputField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person_outline,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Full Name Field
                  _buildInputField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Full name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Divider
                  Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),
                  
                  // Change Password Section Header
                  Text(
                    'Change Password (Optional)',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Leave blank if you don\'t want to change password',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 12 : 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Password Field
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'New Password',
                    obscure: _obscurePassword,
                    enabled: !isLoading,
                    onToggleVisibility: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Confirm Password Field
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    obscure: _obscureConfirmPassword,
                    enabled: !isLoading,
                    onToggleVisibility: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                    validator: (value) {
                      if (_passwordController.text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenWidth < 360 ? 24 : 32),
                  
                  // Save Button
                  _buildSaveButton(isLoading),
                  SizedBox(height: 16),
                  
                  // Cancel Button
                  _buildCancelButton(isLoading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }



  /// Build profile header dengan avatar dan current info
  Widget _buildProfileHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth < 360 ? 70.0 : 80.0;
    final fontSize = screenWidth < 360 ? 16.0 : 18.0;
    
    return Container(
      padding: EdgeInsets.all(screenWidth < 360 ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF7FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            child: Center(
              child: Text(
                _getInitials(widget.currentProfile.fullName),
                style: TextStyle(
                  fontSize: avatarSize * 0.4,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentProfile.fullName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  widget.currentProfile.email,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 12 : 14,
                    color: Color(0xFF718096),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF667EEA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.currentProfile.role.toUpperCase(),
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  /// Build input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF667EEA)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE53E3E)),
        ),
      ),
      validator: validator,
    );
  }



  /// Build password field dengan toggle visibility
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required bool enabled,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF667EEA)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Color(0xFF718096),
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE53E3E)),
        ),
      ),
      validator: validator,
    );
  }



  /// Build save button
  Widget _buildSaveButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading || !_hasChanges ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF667EEA),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFFE2E8F0),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isLoading || !_hasChanges ? 0 : 4,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }



  /// Build cancel button
  Widget _buildCancelButton(bool isLoading) {
    return TextButton(
      onPressed: isLoading ? null : () => Navigator.pop(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Cancel',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isLoading ? Color(0xFFCBD5E0) : Color(0xFF718096),
        ),
      ),
    );
  }



  /// Helper untuk mendapatkan inisial dari nama lengkap
  String _getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }
}
