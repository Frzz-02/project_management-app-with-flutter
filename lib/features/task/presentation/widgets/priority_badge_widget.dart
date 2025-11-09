import 'package:flutter/material.dart';

/// Widget untuk priority badge dengan icon dan background color
///
/// Digunakan di task detail untuk menampilkan priority
/// dengan style yang lebih prominent
///
class PriorityBadgeWidget extends StatelessWidget {
  final String priority;

  const PriorityBadgeWidget({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priorityData.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priorityData.icon, size: 14, color: priorityData.textColor),
          const SizedBox(width: 4),
          Text(
            priorityData.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: priorityData.textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Get priority data berdasarkan priority string
  _PriorityBadgeData _getPriorityData(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return _PriorityBadgeData(
          backgroundColor: const Color(0xFFFEE2E2),
          textColor: const Color(0xFF991B1B),
          icon: Icons.arrow_upward,
          label: 'High',
        );
      case 'medium':
        return _PriorityBadgeData(
          backgroundColor: const Color(0xFFFEF3C7),
          textColor: const Color(0xFF92400E),
          icon: Icons.remove,
          label: 'Medium',
        );
      case 'low':
        return _PriorityBadgeData(
          backgroundColor: const Color(0xFFDCFCE7),
          textColor: const Color(0xFF166534),
          icon: Icons.arrow_downward,
          label: 'Low',
        );
      default:
        return _PriorityBadgeData(
          backgroundColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF6B7280),
          icon: Icons.help_outline,
          label: priority,
        );
    }
  }
}

/// Data class untuk menyimpan informasi priority badge
class _PriorityBadgeData {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final String label;

  _PriorityBadgeData({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.label,
  });
}
