import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:project_management/features/dashboard/presentation/cubits/dashboard_state.dart';

/// Widget utama untuk halaman dashboard
/// Menampilkan overview, tugas saat ini, dan daftar tugas dengan tab bar
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  /// Controller untuk tab bar pada bagian daftar tugas
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi tab controller dengan 3 tab (Todo, In Progress, Done)
    _tabController = TabController(length: 3, vsync: this);
    
    // Fetch dashboard data saat pertama kali load
    context.read<DashboardCubit>().fetchDashboardData();
  }

  @override
  void dispose() {
    // Dispose tab controller untuk mencegah memory leak
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // Jira-like background
      appBar: _buildAppBar(context),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0052CC)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading dashboard...',
                    style: TextStyle(
                      color: Color(0xFF42526E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: Color(0xFFDE350B),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Unable to load dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF42526E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardCubit>().fetchDashboardData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<DashboardCubit>().refreshDashboard(),
              color: const Color(0xFF0052CC),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                  child: isDesktop
                      ? _buildDesktopLayout(state)
                      : _buildMobileLayout(state, isTablet),
                ),
              ),
            );
          }

          // Initial state
          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  /// Desktop layout with two columns
  Widget _buildDesktopLayout(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader(),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildOverviewSection(state.completedTasks, state.averageTime),
                  const SizedBox(height: 24),
                  _buildCurrentTaskSection(state.ongoingTimer),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: _buildTaskListSection(state),
            ),
          ],
        ),
      ],
    );
  }

  /// Mobile/Tablet layout - single column
  Widget _buildMobileLayout(DashboardLoaded state, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader(),
        SizedBox(height: isTablet ? 24 : 20),
        _buildOverviewSection(state.completedTasks, state.averageTime),
        SizedBox(height: isTablet ? 24 : 20),
        _buildCurrentTaskSection(state.ongoingTimer),
        SizedBox(height: isTablet ? 24 : 20),
        _buildTaskListSection(state),
      ],
    );
  }

  /// Page header with title and subtitle
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track your work and stay up to date',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF5E6C84),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

    /// Build AppBar - Jira style clean design
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        children: [
          Image.asset(
            'assets/images/app_logo.png',
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Text(
            'Projects',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Color(0xFF42526E),
            size: 22,
          ),
          onPressed: () {
            // TODO: Show notifications
          },
          tooltip: 'Notifications',
        ),
        PopupMenuButton<int>(
          icon: Icon(
            Icons.more_vert,
            color: Color(0xFF42526E),
            size: 22,
          ),
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xFFDFE1E6), width: 1),
          ),
          offset: const Offset(0, 48),
          itemBuilder: (context) => [
            _buildModernPopupMenuItem(
              value: 1,
              icon: Icons.person_outline,
              title: 'Profile',
              isFirst: true,
            ),
            _buildModernPopupMenuItem(
              value: 2,
              icon: Icons.settings_outlined,
              title: 'Settings',
            ),
            PopupMenuItem<int>(
              enabled: false,
              padding: EdgeInsets.zero,
              height: 1,
              child: Divider(color: Color(0xFFDFE1E6), height: 1),
            ),
            _buildModernPopupMenuItem(
              value: 3,
              icon: Icons.help_outline,
              title: 'Help & Support',
            ),
            _buildModernPopupMenuItem(
              value: 4,
              icon: Icons.logout,
              title: 'Logout',
              isLast: true,
              isDestructive: true,
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 1:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
              case 2:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Settings'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
              case 3:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Help & Support'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
              case 4:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Build modern popup menu item
  PopupMenuItem<int> _buildModernPopupMenuItem({
    required int value,
    required IconData icon,
    required String title,
    bool isFirst = false,
    bool isLast = false,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<int>(
      value: value,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDestructive ? Color(0xFFDE350B) : Color(0xFF42526E),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Color(0xFFDE350B) : Color(0xFF172B4D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk section overview (statistik atas)
  /// Menampilkan tugas selesai dan rata-rata waktu dalam 2 card - Jira style
  Widget _buildOverviewSection(int completedTasks, String averageTime) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your work',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
            const SizedBox(height: 16),
            isWide
                ? Row(
                    children: [
                      Expanded(child: _buildStatCard(
                        title: 'Completed',
                        value: '$completedTasks',
                        subtitle: 'Tasks done',
                        icon: Icons.check_circle_outline,
                        iconColor: Color(0xFF36B37E),
                        backgroundColor: Color(0xFFE3FCEF),
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard(
                        title: 'Avg. Time',
                        value: averageTime,
                        subtitle: 'Per task',
                        icon: Icons.schedule_outlined,
                        iconColor: Color(0xFF0052CC),
                        backgroundColor: Color(0xFFDEEBFF),
                      )),
                    ],
                  )
                : Column(
                    children: [
                      _buildStatCard(
                        title: 'Completed',
                        value: '$completedTasks',
                        subtitle: 'Tasks done',
                        icon: Icons.check_circle_outline,
                        iconColor: Color(0xFF36B37E),
                        backgroundColor: Color(0xFFE3FCEF),
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: 'Avg. Time',
                        value: averageTime,
                        subtitle: 'Per task',
                        icon: Icons.schedule_outlined,
                        iconColor: Color(0xFF0052CC),
                        backgroundColor: Color(0xFFDEEBFF),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }

  /// Build individual stat card - Jira style
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFDFE1E6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5E6C84),
                  letterSpacing: 0.5,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF5E6C84),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk section tugas saat ini - Jira style
  /// Menampilkan tugas yang sedang dikerjakan
  Widget _buildCurrentTaskSection(Map<String, dynamic>? ongoingTimer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: ongoingTimer != null ? Color(0xFFFF5630) : Color(0xFF97A0AF),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Current task',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFDFE1E6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ongoingTimer == null
              ? _buildEmptyCurrentTask()
              : _buildActiveTask(ongoingTimer),
        ),
      ],
    );
  }

  /// Empty state for current task
  Widget _buildEmptyCurrentTask() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF4F5F7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.timer_off_outlined,
            size: 40,
            color: Color(0xFF97A0AF),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No active task',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Start working on a task to track your time',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF5E6C84),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Active task display
  Widget _buildActiveTask(Map<String, dynamic> ongoingTimer) {
    final cardTitle = ongoingTimer['card']?['card_title'] ?? 
                     ongoingTimer['card']?['title'] ?? 'Untitled Task';
    final boardName = ongoingTimer['card']?['board']?['board_name'] ?? 
                     ongoingTimer['card']?['board']?['name'] ?? 'No Board';
    final startTime = ongoingTimer['start_time'] ?? '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF42526E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                boardName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF42526E),
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5630),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'IN PROGRESS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFDE350B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          cardTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: Color(0xFF42526E),
              ),
              const SizedBox(width: 8),
              Text(
                'Started ${_formatTime(startTime)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF42526E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to format time - improved
  String _formatTime(String timeString) {
    if (timeString.isEmpty) return 'Unknown';
    try {
      final dateTime = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inHours > 0) {
        return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return timeString;
    }
  }

  /// Widget untuk section daftar tugas - Jira style
  /// Menampilkan tugas dalam 3 kategori dengan tab bar modern
  Widget _buildTaskListSection(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your tasks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFDFE1E6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Modern Tab Bar
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFDFE1E6), width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF0052CC),
                  unselectedLabelColor: Color(0xFF5E6C84),
                  indicatorColor: Color(0xFF0052CC),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('To Do'),
                          const SizedBox(width: 6),
                          _buildTaskCount(state.getCardsByStatus('todo').length, Color(0xFF97A0AF)),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('In Progress'),
                          const SizedBox(width: 6),
                          _buildTaskCount(state.getCardsByStatus('in progress').length, Color(0xFF0052CC)),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Done'),
                          const SizedBox(width: 6),
                          _buildTaskCount(state.getCardsByStatus('done').length, Color(0xFF36B37E)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Tab Bar Content
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(state, 'todo'),
                    _buildTaskList(state, 'in progress'),
                    _buildTaskList(state, 'done'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build task count badge
  Widget _buildTaskCount(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  /// Widget untuk membangun list tugas - Jira style cards
  /// [state] - Dashboard state with cards data
  /// [status] - status tugas (todo, in progress, done)
  Widget _buildTaskList(DashboardLoaded state, String status) {
    final cards = state.getCardsByStatus(status);

    if (cards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.task_alt,
                  size: 40,
                  color: Color(0xFF97A0AF),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tasks will appear here when created',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5E6C84),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final card = cards[index];
        final boardName = card['board_name'] ?? 'No Board';
        final title = card['card_title'] ?? 'Untitled';
        final priority = card['priority']?.toString().toLowerCase() ?? 'medium';
        final dueDate = card['due_date'];
        
        return _buildTaskCard(
          title: title,
          boardName: boardName,
          priority: priority,
          dueDate: dueDate,
          status: status,
        );
      },
    );
  }

  /// Build individual task card - Jira style
  Widget _buildTaskCard({
    required String title,
    required String boardName,
    required String priority,
    String? dueDate,
    required String status,
  }) {
    final priorityColor = _getPriorityColor(priority);
    final isOverdue = dueDate != null && DateTime.parse(dueDate).isBefore(DateTime.now());
    
    return InkWell(
      onTap: () {
        // TODO: Navigate to task detail
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xFFDFE1E6), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with board name and priority
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFF42526E).withOpacity(0.06),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      boardName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42526E),
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Task title
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF172B4D),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: isOverdue ? Color(0xFFDE350B) : Color(0xFF5E6C84),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDeadline(dueDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Color(0xFFDE350B) : Color(0xFF5E6C84),
                      fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Format deadline with better labels
  String _formatDeadline(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = date.difference(now);
      
      if (difference.inDays < 0) {
        return 'Overdue';
      } else if (difference.inDays == 0) {
        return 'Due today';
      } else if (difference.inDays == 1) {
        return 'Due tomorrow';
      } else if (difference.inDays <= 7) {
        return 'Due in ${difference.inDays} days';
      } else {
        return 'Due ${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Get priority color - Jira style
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'highest':
      case 'high':
        return Color(0xFFDE350B);
      case 'medium':
        return Color(0xFFFF991F);
      case 'low':
      case 'lowest':
        return Color(0xFF36B37E);
      default:
        return Color(0xFF97A0AF);
    }
  }
}
