import 'package:flutter/material.dart';

/// Widget untuk status badge dengan warna yang sesuai
///
/// Widget ini menampilkan status task dengan warna background
/// dan text color yang berbeda untuk setiap status
///
class StatusBadgeWidget extends StatelessWidget {
  final String status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusData.displayText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: statusData.textColor,
        ),
      ),
    );
  }

  /// Get status data berdasarkan status string
  _StatusData _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
        return _StatusData(
          backgroundColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF374151),
          displayText: 'To Do',
        );
      case 'in_progress':
        return _StatusData(
          backgroundColor: const Color(0xFFEFF6FF),
          textColor: const Color(0xFF2563EB),
          displayText: 'In Progress',
        );
      case 'in_review':
        return _StatusData(
          backgroundColor: const Color(0xFFFEF3C7),
          textColor: const Color(0xFFD97706),
          displayText: 'In Review',
        );
      case 'done':
      case 'completed':
        return _StatusData(
          backgroundColor: const Color(0xFFDCFCE7),
          textColor: const Color(0xFF16A34A),
          displayText: 'Done',
        );
      default:
        return _StatusData(
          backgroundColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF374151),
          displayText: status,
        );
    }
  }
}

/// Data class untuk menyimpan informasi status
class _StatusData {
  final Color backgroundColor;
  final Color textColor;
  final String displayText;

  _StatusData({
    required this.backgroundColor,
    required this.textColor,
    required this.displayText,
  });
}
