import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:project_management/features/card/domain/repositories/card_repository.dart';
import 'dashboard_state.dart';

/// Dashboard Cubit
///
/// Cubit untuk state management Dashboard feature
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository dashboardRepository;
  final CardRepository cardRepository;

  DashboardCubit({
    required this.dashboardRepository,
    required this.cardRepository,
  }) : super(const DashboardInitial());

  /// Fetch all dashboard data
  Future<void> fetchDashboardData() async {
    try {
      emit(const DashboardLoading());
      print('🔄 Memulai fetch dashboard data...');

      Map<String, dynamic> stats = {
        'completed_tasks': 0,
        'average_time': '0 menit',
      };
      Map<String, dynamic>? ongoingTimer;
      List<Map<String, dynamic>> cardsMap = [];

      // Fetch data satu per satu dengan fallback
      try {
        print('📊 Fetching dashboard stats...');
        stats = await dashboardRepository.getDashboardStats();
        print('✅ Stats berhasil: $stats');
      } catch (e) {
        print('⚠️ Stats error (using default): $e');
      }

      try {
        print('⏰ Fetching ongoing timer...');
        ongoingTimer = await dashboardRepository.getOngoingTimer();
        print('✅ Ongoing timer: ${ongoingTimer != null ? "Ada" : "Tidak ada"}');
      } catch (e) {
        print('⚠️ Ongoing timer error (using null): $e');
      }

      try {
        print('📋 Fetching cards...');
        final cards = await cardRepository.getCards();
        print('✅ Cards berhasil: ${cards.length} cards');

        // Convert cards ke Map for easier handling
        cardsMap = cards.map((card) {
          return {
            'id': card.id,
            'card_title': card.cardTitle,
            'description': card.description,
            'status': card.status,
            'priority': card.priority,
            'due_date': card.dueDate,
            'board_name': card.board.boardName,
            'estimated_hours': card.estimatedHours,
            'actual_hours': card.actualHours,
            'creator_name': card.creator.fullName,
          };
        }).toList();
      } catch (e) {
        print('⚠️ Cards error (using empty list): $e');
      }

      print('📦 Total cards dalam map: ${cardsMap.length}');

      emit(
        DashboardLoaded(
          completedTasks: stats['completed_tasks'] ?? 0,
          averageTime: stats['average_time'] ?? '0 menit',
          ongoingTimer: ongoingTimer,
          allCards: cardsMap,
        ),
      );

      print('✅ Berhasil fetch dashboard data');
    } catch (e, stackTrace) {
      final errorMessage = 'Gagal memuat dashboard: ${e.toString()}';
      emit(DashboardError(message: errorMessage));
      print('❌ Error saat fetch dashboard: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
