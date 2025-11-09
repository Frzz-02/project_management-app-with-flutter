import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/card/domain/entities/card.dart'
    as entity;
import 'package:project_management/features/task/presentation/widgets/status_badge_widget.dart';
import 'package:project_management/features/task/presentation/widgets/priority_badge_widget.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_cubit.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_state.dart';
import 'package:project_management/features/time_log/presentation/widgets/time_log_dialogs.dart';
import 'package:project_management/features/task/presentation/pages/subtask_page.dart';
import 'package:project_management/core/utils/date_formatter.dart';

/// Bottom sheet untuk menampilkan detail task
///
/// Widget ini menampilkan informasi lengkap task dalam
/// format DraggableScrollableSheet yang modern dan interaktif
///
class TaskDetailSheet extends StatelessWidget {
  final entity.Card card;

  const TaskDetailSheet({super.key, required this.card});

  /// Static method untuk menampilkan bottom sheet
  static void show(BuildContext context, entity.Card card) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar with close button
            _buildHeader(context),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusAndPriority(),
                    const SizedBox(height: 16),
                    _buildTitle(),
                    const SizedBox(height: 24),
                    _buildDescriptionCard(),
                    const SizedBox(height: 24),
                    _buildProjectAndBoardCard(),
                    const SizedBox(height: 16),
                    _buildTimeTrackingCards(),
                    const SizedBox(height: 16),
                    _buildCreatorCard(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk header dengan handle bar dan close button
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Color(0xFF64748B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// Widget untuk status badge dan priority badge
  Widget _buildStatusAndPriority() {
    return Row(
      children: [
        StatusBadgeWidget(status: card.status),
        const SizedBox(width: 8),
        PriorityBadgeWidget(priority: card.priority),
        const Spacer(),
        Icon(Icons.calendar_today, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          DateFormatter.formatDate(card.dueDate),
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  /// Widget untuk title
  Widget _buildTitle() {
    return Text(
      card.cardTitle,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
        height: 1.3,
      ),
    );
  }

  /// Widget untuk description card
  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            card.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF475569),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk project dan board card
  Widget _buildProjectAndBoardCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.folder_outlined,
            label: 'Project',
            value: card.board.project.projectName,
            isLight: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white24, height: 1),
          ),
          _InfoRow(
            icon: Icons.dashboard_outlined,
            label: 'Board',
            value: card.board.boardName,
            isLight: true,
          ),
        ],
      ),
    );
  }

  /// Widget untuk time tracking cards
  Widget _buildTimeTrackingCards() {
    return Row(
      children: [
        Expanded(
          child: _TimeCard(
            label: 'Estimated',
            value: '${card.estimatedHours}h',
            icon: Icons.timer_outlined,
            color: const Color(0xFF8B5CF6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TimeCard(
            label: 'Actual',
            value: '${card.actualHours}h',
            icon: Icons.schedule,
            color: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  /// Widget untuk creator card
  Widget _buildCreatorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
            child: Text(
              card.creator.fullName.isNotEmpty
                  ? card.creator.fullName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Created by',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Text(
                  card.creator.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk action buttons (Start Time, Subtask, Close)
  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<TimeLogCubit, TimeLogState>(
      builder: (context, timeLogState) {
        // Check apakah task ini sedang running
        final isRunning =
            timeLogState is TimeLogRunning &&
            timeLogState.timeLog.cardId == card.id;

        // Check apakah ada task lain yang running
        final hasOtherRunningTask =
            timeLogState is TimeLogRunning &&
            timeLogState.timeLog.cardId != card.id;

        return Column(
          children: [
            // Start Time Button
            if (!isRunning)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: hasOtherRunningTask
                      ? null
                      : () => _handleStartTimeLog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasOtherRunningTask
                        ? Colors.grey.shade300
                        : Colors.green.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    hasOtherRunningTask ? Icons.block : Icons.play_arrow,
                    size: 24,
                  ),
                  label: Text(
                    hasOtherRunningTask
                        ? 'Another Task Running'
                        : 'Start Time Tracking',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else
              // Running indicator
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.green.shade700, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Running: ${timeLogState.formattedElapsedTime}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Subtask Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: isRunning
                    ? () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubtaskPage(card: card),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade200,
                  disabledForegroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.checklist, size: 24),
                label: Text(
                  isRunning ? 'Manage Subtasks' : 'Subtasks (Start Task First)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Close Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Handle start time log
  Future<void> _handleStartTimeLog(BuildContext context) async {
    final result = await showStartTimeLogDialog(
      context: context,
      cardTitle: card.cardTitle,
    );

    if (result != null && result['confirmed'] == true) {
      if (context.mounted) {
        context.read<TimeLogCubit>().startTimeLog(
          cardId: card.id,
          description: result['description'],
        );

        // Close the bottom sheet
        Navigator.pop(context);
      }
    }
  }
}

/// Widget helper untuk info row
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLight;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isLight ? Colors.white : const Color(0xFF64748B),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isLight
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isLight ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget helper untuk time card
class _TimeCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TimeCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
