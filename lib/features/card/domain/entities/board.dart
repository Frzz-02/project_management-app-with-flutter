import 'package:project_management/features/card/domain/entities/project.dart';

/// Board Entity
///
/// Entity untuk representasi data board di domain layer
/// Board adalah tempat dimana cards dikelompokkan berdasarkan project
///
class Board {
  final int id;
  final int projectId;
  final String boardName;
  final String description;
  final int position;
  final String createdAt;
  final Project project;

  const Board({
    required this.id,
    required this.projectId,
    required this.boardName,
    required this.description,
    required this.position,
    required this.createdAt,
    required this.project,
  });
}
