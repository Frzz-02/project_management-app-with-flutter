import 'package:project_management/features/card/data/models/project_model.dart';
import '../../domain/entities/board.dart';

/// Board Model
///
/// Model untuk mapping data board dari/ke JSON
/// Extends dari Board entity dan menambahkan factory method untuk parsing
///
class BoardModel extends Board {
  const BoardModel({
    required super.id,
    required super.projectId,
    required super.boardName,
    required super.description,
    required super.position,
    required super.createdAt,
    required super.project,
  });

  /// Factory method untuk membuat BoardModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data board dari API response
  /// Returns BoardModel instance dengan nested ProjectModel
  ///
  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] as int,
      projectId: json['project_id'] as int? ?? 0,
      boardName: json['board_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      project: ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
    );
  }

  /// Method untuk convert BoardModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'board_name': boardName,
      'description': description,
      'position': position,
      'created_at': createdAt,
      'project': (project as ProjectModel).toJson(),
    };
  }
}
