import 'package:project_management/features/card/domain/entities/user.dart';

/// Assignment Entity
///
/// Entity untuk representasi data assignment di domain layer
/// Assignment menghubungkan user dengan card yang ditugaskan
///
class Assignment {
  final int id;
  final int cardId;
  final int userId;
  final String assignedAt;
  final String assignmentStatus;
  final String? startedAt;
  final String? completedAt;
  final User user;

  const Assignment({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.assignedAt,
    required this.assignmentStatus,
    this.startedAt,
    this.completedAt,
    required this.user,
  });
}
