import 'package:project_management/features/card/data/models/user_model.dart';
import '../../domain/entities/assignment.dart';

/// Assignment Model
///
/// Model untuk mapping data assignment dari/ke JSON
/// Extends dari Assignment entity dan menambahkan factory method untuk parsing
///
class AssignmentModel extends Assignment {
  const AssignmentModel({
    required super.id,
    required super.cardId,
    required super.userId,
    required super.assignedAt,
    required super.assignmentStatus,
    super.startedAt,
    super.completedAt,
    required super.user,
  });

  /// Factory method untuk membuat AssignmentModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data assignment dari API response
  /// Returns AssignmentModel instance dengan nested UserModel
  ///
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      cardId: json['card_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      assignedAt: json['assigned_at'] as String? ?? '',
      assignmentStatus: json['assignment_status'] as String? ?? '',
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  /// Method untuk convert AssignmentModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'user_id': userId,
      'assigned_at': assignedAt,
      'assignment_status': assignmentStatus,
      'started_at': startedAt,
      'completed_at': completedAt,
      'user': (user as UserModel).toJson(),
    };
  }
}
