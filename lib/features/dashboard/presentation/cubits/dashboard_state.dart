import 'package:equatable/equatable.dart';

/// Dashboard State
///
/// State untuk dashboard feature
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Loading state
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Loaded state with dashboard data
class DashboardLoaded extends DashboardState {
  final int completedTasks;
  final String averageTime;
  final Map<String, dynamic>? ongoingTimer;
  final List<Map<String, dynamic>> allCards;

  const DashboardLoaded({
    required this.completedTasks,
    required this.averageTime,
    this.ongoingTimer,
    required this.allCards,
  });

  @override
  List<Object?> get props => [
    completedTasks,
    averageTime,
    ongoingTimer,
    allCards,
  ];

  /// Helper untuk filter cards by status
  List<Map<String, dynamic>> getCardsByStatus(String status) {
    return allCards.where((card) {
      final cardStatus = card['status']?.toString().toLowerCase() ?? '';
      return cardStatus == status.toLowerCase();
    }).toList();
  }
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
