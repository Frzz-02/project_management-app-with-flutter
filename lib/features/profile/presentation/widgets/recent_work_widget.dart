import 'package:flutter/material.dart';
import 'package:project_management/features/profile/data/models/user_profile_model.dart';



/// Widget untuk menampilkan daftar pekerjaan terkini
/// 
/// Menampilkan kartu-kartu tugas yang dibuat oleh pengguna
/// dengan status, priority, dan board information
class RecentWorkWidget extends StatelessWidget {
  final List<CardModel> cards;
  final Function(CardModel) onCardTap;



  /// Constructor dengan parameter cards dan callback
  /// 
  /// [cards] List kartu tugas yang akan ditampilkan
  /// [onCardTap] Callback ketika salah satu card di-tap
  const RecentWorkWidget({
    Key? key,
    required this.cards,
    required this.onCardTap,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 18.0 : (screenWidth < 600 ? 20.0 : 22.0);
    
    // Ambil hanya 3 kartu terbaru
    final recentCards = cards.take(3).toList();

    return Container(
      width: double.infinity, // Full width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Work',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all cards page
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth < 360 ? 13.0 : 14.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth < 360 ? 12 : 16),
          
          // Display cards or empty state
          if (recentCards.isEmpty)
            _buildEmptyState(context)
          else
            ...recentCards.map((card) => _buildWorkItem(context, card)).toList(),
        ],
      ),
    );
  }



  /// Build individual work item card
  /// 
  /// [context] BuildContext untuk responsive sizing
  /// [card] Data kartu tugas yang akan ditampilkan
  Widget _buildWorkItem(BuildContext context, CardModel card) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusColor = _getStatusColor(card.status);
    final priorityIcon = _getPriorityIcon(card.priority);
    
    final cardPadding = screenWidth < 360 ? 12.0 : 16.0;
    final iconSize = screenWidth < 360 ? 20.0 : 24.0;
    final iconPadding = screenWidth < 360 ? 8.0 : 10.0;
    final titleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final subtitleFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final badgeFontSize = screenWidth < 360 ? 10.0 : 12.0;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () => onCardTap(card),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.only(bottom: screenWidth < 360 ? 8 : 12),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(priorityIcon, color: statusColor, size: iconSize),
              ),
              SizedBox(width: screenWidth < 360 ? 12 : 16),
              
              // Card info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.cardTitle,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      card.board?.boardName ?? 'No Board',
                      style: TextStyle(fontSize: subtitleFontSize, color: Color(0xFF718096)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 8 : 12,
                  vertical: screenWidth < 360 ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatStatus(card.status),
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: screenWidth < 360 ? 4 : 8),
              Icon(Icons.arrow_forward_ios, color: Color(0xFFCBD5E0), size: 16),
            ],
          ),
        ),
      ),
    );
  }



  /// Build empty state ketika tidak ada kartu
  /// Build empty state widget ketika tidak ada kartu
  /// 
  /// [context] BuildContext untuk responsive sizing
  Widget _buildEmptyState(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 360 ? 20.0 : 32.0;
    final iconSize = screenWidth < 360 ? 48.0 : 64.0;
    final titleFontSize = screenWidth < 360 ? 16.0 : 18.0;
    final subtitleFontSize = screenWidth < 360 ? 12.0 : 14.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_outline,
            size: iconSize,
            color: Color(0xFFCBD5E0),
          ),
          SizedBox(height: screenWidth < 360 ? 12 : 16),
          Text(
            'No Recent Work',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your created cards will appear here',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  /// Helper untuk mendapatkan warna berdasarkan status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
      case 'to do':
        return Color(0xFF718096);
      case 'in progress':
        return Color(0xFFED8936);
      case 'review':
        return Color(0xFF9F7AEA);
      case 'done':
        return Color(0xFF48BB78);
      default:
        return Color(0xFF718096);
    }
  }



  /// Helper untuk mendapatkan icon berdasarkan priority
  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'highest':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
      case 'lowest':
        return Icons.arrow_downward;
      default:
        return Icons.task;
    }
  }



  /// Helper untuk format status text
  String _formatStatus(String status) {
    return status.split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
  }
}
