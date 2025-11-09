import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/card/domain/entities/card.dart'
    as entity;
import 'package:project_management/features/time_log/presentation/cubits/time_log_cubit.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_state.dart';
import 'package:project_management/features/task/presentation/widgets/status_badge_widget.dart';
import 'package:project_management/features/task/presentation/widgets/priority_indicator_widget.dart';
import 'package:project_management/core/utils/date_formatter.dart';
import 'package:project_management/core/utils/string_helper.dart';

/// Widget untuk task card yang dapat diklik dan interaktif
///
/// Widget ini menampilkan card dengan informasi task lengkap,
/// termasuk time tracking button (Start/Stop) dan button Tandai Selesai
///
class TaskCardWidget extends StatelessWidget {
  final entity.Card card;
  final int? startingCardId;
  final VoidCallback onTap;
  final VoidCallback onStartTimeLog;
  final VoidCallback onStopTimeLog;
  final VoidCallback? onMarkAsCompleted;

  const TaskCardWidget({
    super.key,
    required this.card,
    required this.startingCardId,
    required this.onTap,
    required this.onStartTimeLog,
    required this.onStopTimeLog,
    this.onMarkAsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeLogCubit, TimeLogState>(
      builder: (context, timeLogState) {
        // Check apakah card ini yang sedang running
        final isRunning =
            timeLogState is TimeLogRunning &&
            timeLogState.timeLog.cardId == card.id;

        // Check apakah ada time log yang sedang running (untuk card lain)
        final hasOtherRunningTimeLog =
            timeLogState is TimeLogRunning &&
            timeLogState.timeLog.cardId != card.id;

        // Check status loading - HANYA untuk card yang spesifik ini
        final isStarting =
            startingCardId == card.id && timeLogState is TimeLogStarting;
        final isStopping = timeLogState is TimeLogStopping && isRunning;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isRunning
                ? Border.all(color: Colors.green.shade300, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan ID dan status
                    Row(
                      children: [
                        // Task ID
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'TSK-${card.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Status badge
                        StatusBadgeWidget(status: card.status),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Task title
                    Text(
                      card.cardTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Task description
                    Text(
                      card.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Timer display jika card ini sedang running
                    if (isRunning) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Running: ${timeLogState.formattedElapsedTime}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Task metadata
                    Row(
                      children: [
                        // Priority indicator
                        PriorityIndicatorWidget(priority: card.priority),

                        const Spacer(),

                        // Due date
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatDate(card.dueDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Bottom row dengan assignee dan actions
                    Row(
                      children: [
                        // Assignee avatar dan nama
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color(0xFF3B82F6),
                              child: Text(
                                StringHelper.getInitials(card.creator.fullName),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              card.creator.fullName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Action buttons - Time Tracking
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isRunning)
                              // Card ini sedang running - tampilkan tombol STOP
                              _buildStopButton(isStopping)
                            else if (hasOtherRunningTimeLog)
                              // Ada card lain yang running - disable tombol START
                              _buildDisabledStartButton()
                            else
                              // Tidak ada yang running - tampilkan tombol START
                              _buildStartButton(isStarting),
                          ],
                        ),
                      ],
                    ),

                    // Button Tandai Selesai
                    // Tampilkan hanya jika status in_progress atau in_review
                    // Hide jika status done
                    if (card.status != 'done') ...[
                      const SizedBox(height: 12),
                      _buildMarkAsCompletedButton(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Widget untuk button "Tandai Selesai"
  ///
  /// LOGIC BARU (tanpa wajib start timer):
  /// - Enabled (hijau) jika status BUKAN 'review' dan BUKAN 'done'
  /// - Disabled (abu-abu) jika status 'review' dengan text "Menunggu review..."
  /// - Hidden jika status 'done'
  ///
  /// User bisa langsung tandai selesai dari status apapun (to_do, in_progress)
  ///
  Widget _buildMarkAsCompletedButton() {
    final isReview = card.status == 'review';
    final isDone = card.status == 'done';

    // Jika status review, tampilkan disabled button
    if (isReview) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              'Menunggu review oleh Team Lead...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Jika status done, hide button (tidak tampil)
    if (isDone) {
      return const SizedBox.shrink();
    }

    // Untuk semua status lainnya (to_do, in_progress), tampilkan enabled button
    // USER BISA LANGSUNG TANDAI SELESAI tanpa harus start timer dulu
    return GestureDetector(
      onTap: onMarkAsCompleted,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Tandai Selesai',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk tombol START
  Widget _buildStartButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : onStartTimeLog,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey.shade100 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.play_arrow, size: 16, color: Colors.green.shade700),
      ),
    );
  }

  /// Widget untuk tombol STOP
  Widget _buildStopButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : onStopTimeLog,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey.shade100 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.stop, size: 16, color: Colors.red.shade700),
      ),
    );
  }

  /// Widget untuk tombol START yang disabled
  Widget _buildDisabledStartButton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.play_arrow, size: 16, color: Colors.grey.shade400),
    );
  }
}
