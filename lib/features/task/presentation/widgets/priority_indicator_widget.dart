import 'package:flutter/material.dart';

/// Widget untuk priority indicator dengan icon dan warna
///
/// Widget ini menampilkan priority task dengan icon arrow
/// dan warna yang berbeda untuk setiap level priority
///
class PriorityIndicatorWidget extends StatelessWidget {
  final String priority;

  const PriorityIndicatorWidget({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData(priority);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(priorityData.icon, size: 16, color: priorityData.color),
        const SizedBox(width: 2),
        Text(
          priorityData.displayText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: priorityData.color,
          ),
        ),
      ],
    );
  }

  /// Get priority data berdasarkan priority string
  _PriorityData _getPriorityData(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return _PriorityData(
          color: const Color(0xFFEF4444),
          icon: Icons.keyboard_arrow_up,
          displayText: 'High',
        );
      case 'medium':
        return _PriorityData(
          color: const Color(0xFFF59E0B),
          icon: Icons.remove,
          displayText: 'Medium',
        );
      case 'low':
        return _PriorityData(
          color: const Color(0xFF10B981),
          icon: Icons.keyboard_arrow_down,
          displayText: 'Low',
        );
      default:
        return _PriorityData(
          color: const Color(0xFF64748B),
          icon: Icons.remove,
          displayText: priority,
        );
    }
  }
}

/// Data class untuk menyimpan informasi priority
class _PriorityData {
  final Color color;
  final IconData icon;
  final String displayText;

  _PriorityData({
    required this.color,
    required this.icon,
    required this.displayText,
  });
}
