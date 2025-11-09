import '../../domain/entities/project.dart';

/// Project Model
///
/// Model untuk mapping data project dari/ke JSON
/// Extends dari Project entity dan menambahkan factory method untuk parsing
///
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.projectName,
    required super.description,
    required super.createdBy,
    required super.deadline,
    required super.createdAt,
  });

  /// Factory method untuk membuat ProjectModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data project dari API response
  /// Returns ProjectModel instance
  ///
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      projectName: json['project_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdBy: json['created_by'] as int? ?? 0,
      deadline: json['deadline'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Method untuk convert ProjectModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'description': description,
      'created_by': createdBy,
      'deadline': deadline,
      'created_at': createdAt,
    };
  }
}
