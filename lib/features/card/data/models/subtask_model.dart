import '../../domain/entities/subtask.dart';

/// Subtask Model
///
/// Model untuk mapping data subtask dari/ke JSON
/// Extends dari Subtask entity dan menambahkan factory method untuk parsing
///
class SubtaskModel extends Subtask {
  const SubtaskModel({
    required super.id,
    required super.cardId,
    required super.subtaskTitle,
    super.description,
    required super.status,
    required super.position,
    required super.createdAt,
  });

  /// Factory method untuk membuat SubtaskModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data subtask dari API response
  /// Returns SubtaskModel instance
  ///
  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'] as int,
      cardId: json['card_id'] as int? ?? 0,
      subtaskTitle: json['subtask_title'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Method untuk convert SubtaskModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'subtask_title': subtaskTitle,
      'description': description,
      'status': status,
      'position': position,
      'created_at': createdAt,
    };
  }
}
