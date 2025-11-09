import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/card/presentation/cubits/card_cubit.dart';
import 'package:project_management/features/card/presentation/cubits/card_state.dart';
import 'package:project_management/features/card/domain/entities/card.dart'
    as entity;
import 'package:project_management/features/time_log/presentation/cubits/time_log_cubit.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_state.dart';
import 'package:project_management/features/time_log/presentation/widgets/time_log_dialogs.dart';
import 'package:project_management/features/time_log/presentation/widgets/timer_display_widget.dart';
import 'package:project_management/features/task/presentation/widgets/task_card_widget.dart';
import 'package:project_management/features/task/presentation/widgets/task_detail_sheet.dart';

/// Halaman My Task untuk Developer/Designer
///
/// Halaman ini menampilkan daftar tugas dengan interface mirip Jira
/// yang dioptimasi untuk mobile-friendly, performa tinggi, dan user experience
/// yang intuitif. Semua komponen interaktif berfungsi dengan baik.
/// Data diambil dari API menggunakan CardCubit untuk state management.
///
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  static const String routeName = '/task';

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  /// Controller untuk animasi dan tab navigation
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  /// State management untuk filter dan sorting
  String _selectedFilter = 'All';
  String _selectedSort = 'Priority';
  bool _isFilterExpanded = false;

  /// Track card yang sedang dalam proses start (untuk loading indicator)
  int? _startingCardId;

  @override
  void initState() {
    super.initState();
    // Inisialisasi animasi untuk filter
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );

    // Fetch cards dari API saat halaman pertama kali dibuka
    context.read<CardCubit>().fetchCards();
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    super.dispose();
  }

  /// Fungsi untuk menerapkan filter dan sorting pada list cards
  ///
  /// [cards] adalah list card dari API yang akan difilter dan disort
  /// Returns list card yang sudah difilter dan disort
  ///
  List<entity.Card> _applyFiltersAndSort(List<entity.Card> cards) {
    List<entity.Card> filtered = [];

    // Filter berdasarkan status
    if (_selectedFilter == 'All') {
      filtered = List.from(cards);
    } else {
      final filterStatus = _selectedFilter.toLowerCase().replaceAll(' ', '_');
      filtered = cards.where((card) => card.status == filterStatus).toList();
    }

    // Sorting berdasarkan kriteria yang dipilih
    switch (_selectedSort) {
      case 'Priority':
        filtered.sort(
          (a, b) => _getPriorityOrder(
            b.priority,
          ).compareTo(_getPriorityOrder(a.priority)),
        );
        break;
      case 'Due Date':
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
    }

    return filtered;
  }

  /// Helper function untuk urutan prioritas
  ///
  /// [priority] adalah string priority (high, medium, low)
  /// Returns integer untuk sorting (higher = more priority)
  ///
  int _getPriorityOrder(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimeLogCubit, TimeLogState>(
      listener: (context, timeLogState) {
        // Handle error
        if (timeLogState is TimeLogError) {
          // Reset starting card ID saat error
          setState(() {
            _startingCardId = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(timeLogState.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        // Handle success stop
        else if (timeLogState is TimeLogStopped) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Time log dihentikan: ${timeLogState.timeLog.durationFormatted ?? "N/A"}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Handle berhasil start - reset starting card ID
        else if (timeLogState is TimeLogRunning) {
          setState(() {
            _startingCardId = null;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Filter dan Sort Section
            _buildFilterSection(),

            // Task List dengan BlocBuilder
            Expanded(
              child: BlocBuilder<CardCubit, CardState>(
                builder: (context, state) {
                  return switch (state) {
                    // State Initial
                    CardInitial() => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: const Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome to My Tasks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pull down to refresh tasks',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // State Loading
                    CardLoading() => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading tasks...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // State Loaded
                    CardLoaded(:final cards) => _buildTaskList(cards),

                    // State Error
                    CardError(:final message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error Loading Tasks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CardCubit>().fetchCards();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                            ),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  };
                },
              ),
            ),
          ],
        ),

        // Floating Action Button dihapus - tidak perlu CRUD
      ),
    );
  }

  /// Widget untuk AppBar dengan search functionality
  ///
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'My Tasks',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Timer Display (show saat running)
        BlocBuilder<TimeLogCubit, TimeLogState>(
          builder: (context, timeLogState) {
            if (timeLogState is TimeLogRunning) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: TimerDisplayWidget(
                    elapsedTime: timeLogState.formattedElapsedTime,
                    isRunning: true,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Search button
        IconButton(
          onPressed: () => _showSearchDialog(),
          icon: const Icon(Icons.search, color: Color(0xFF64748B)),
        ),
        // Filter toggle button
        IconButton(
          onPressed: _toggleFilter,
          icon: Icon(
            _isFilterExpanded ? Icons.filter_list_off : Icons.filter_list,
            color: _isFilterExpanded
                ? const Color(0xFF3B82F6)
                : const Color(0xFF64748B),
          ),
        ),
        // Refresh button
        IconButton(
          onPressed: () {
            context.read<CardCubit>().refreshCards();
          },
          icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  /// Widget untuk section filter dan sort
  ///
  Widget _buildFilterSection() {
    return AnimatedBuilder(
      animation: _filterAnimation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _filterAnimation,

          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Filter chips
                Row(
                  children: [
                    const Text(
                      'Filter: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'All',
                            'To Do',
                            'In Progress',
                            'In Review',
                            'Done',
                          ].map((filter) => _buildFilterChip(filter)).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Sort dropdown
                Row(
                  children: [
                    const Text(
                      'Sort by: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),

                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedSort,
                        isExpanded: true,
                        underline: Container(),

                        items: ['Priority', 'Due Date']
                            .map(
                              (sort) => DropdownMenuItem(
                                value: sort,
                                child: Text(sort),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSort = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget untuk filter chip yang dapat diklik
  ///
  /// [filter] adalah nama filter yang akan ditampilkan
  ///
  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            filter,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget untuk daftar task dengan optimasi performa
  ///
  /// [cards] adalah list card dari API yang akan ditampilkan
  ///
  Widget _buildTaskList(List<entity.Card> cards) {
    // Apply filter dan sort
    final filteredCards = _applyFiltersAndSort(cards);

    if (filteredCards.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CardCubit>().refreshCards();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCards.length,
        itemBuilder: (context, index) {
          final card = filteredCards[index];
          return _buildTaskCard(card, index);
        },
      ),
    );
  }

  /// Widget untuk task card yang dapat diklik dan interaktif
  ///
  /// [card] adalah data card dari API
  /// [index] adalah index card di list
  ///
  Widget _buildTaskCard(entity.Card card, int index) {
    return TaskCardWidget(
      card: card,
      startingCardId: _startingCardId,
      onTap: () => TaskDetailSheet.show(context, card),
      onStartTimeLog: () => _handleStartTimeLog(context, card),
      onStopTimeLog: () {
        final timeLogState = context.read<TimeLogCubit>().state;
        if (timeLogState is TimeLogRunning) {
          _handleStopTimeLog(context, timeLogState.formattedElapsedTime);
        }
      },
      onMarkAsCompleted: () => _handleMarkAsCompleted(context, card),
    );
  }

  /// Widget untuk empty state ketika tidak ada task
  ///
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),

          const Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Try adjusting your filters or create a new task',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              // Tidak ada action - CRUD dihapus
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6).withOpacity(0.5),
            ),
            icon: const Icon(Icons.info_outline),
            label: const Text('CRUD disabled - Time tracking only'),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk toggle filter section
  ///
  void _toggleFilter() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });

    if (_isFilterExpanded) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  /// Fungsi untuk menampilkan dialog search
  ///
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter task title...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // TODO: Implementasi search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementasi search
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk memulai time log
  ///
  /// [context] adalah BuildContext
  /// [card] adalah data card yang akan ditracking
  ///
  Future<void> _handleStartTimeLog(
    BuildContext context,
    entity.Card card,
  ) async {
    // Show confirmation dialog
    final result = await showStartTimeLogDialog(
      context: context,
      cardTitle: card.cardTitle,
    );

    if (result != null && result['confirmed'] == true) {
      // Set starting card ID untuk loading indicator
      setState(() {
        _startingCardId = card.id;
      });

      // Start time log via cubit
      if (context.mounted) {
        context.read<TimeLogCubit>().startTimeLog(
          cardId: card.id,
          description: result['description'],
        );
      }
    }
  }

  /// Fungsi untuk menghentikan time log
  ///
  /// [context] adalah BuildContext
  /// [elapsedTime] adalah waktu yang sudah berjalan dalam format HH:MM:SS
  ///
  Future<void> _handleStopTimeLog(
    BuildContext context,
    String elapsedTime,
  ) async {
    // Show confirmation dialog
    final result = await showStopTimeLogDialog(
      context: context,
      elapsedTime: elapsedTime,
    );

    if (result != null && result['confirmed'] == true) {
      // Stop time log via cubit
      if (context.mounted) {
        context.read<TimeLogCubit>().stopTimeLog(
          description: result['description'],
        );
      }
    }
  }

  /// Fungsi untuk menandai task sebagai selesai (update status ke review)
  ///
  /// [context] adalah BuildContext
  /// [card] adalah data card yang akan diupdate statusnya
  ///
  /// TIDAK PERLU START TIMER DULU - Bisa langsung tandai selesai dari status apapun
  /// (to_do, in_progress, dll) sesuai logic API Laravel
  ///
  Future<void> _handleMarkAsCompleted(
    BuildContext context,
    entity.Card card,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tandai Selesai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menandai task ini sebagai selesai?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Informasi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Status akan berubah menjadi "In Review"\n'
                    '• Task akan menunggu approval dari Team Lead\n'
                    '• Hanya Team Lead yang dapat mengubah status ke "Done"',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: const Text('Ya, Tandai Selesai'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Update status via cubit
      context.read<CardCubit>().markCardAsCompleted(card.id.toString());

      // Show success message (akan muncul setelah refresh)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Task berhasil ditandai selesai dan menunggu review'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
