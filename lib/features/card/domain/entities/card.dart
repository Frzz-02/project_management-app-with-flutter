import 'package:project_management/features/card/domain/entities/assignment.dart';
import 'package:project_management/features/card/domain/entities/board.dart';
import 'package:project_management/features/card/domain/entities/comment.dart';
import 'package:project_management/features/card/domain/entities/subtask.dart';
import 'package:project_management/features/card/domain/entities/user.dart';

/// Card Entity
///
/// Entity utama untuk representasi data card di domain layer
/// Card adalah unit kerja utama yang berisi detail task, assignments, subtasks, dan comments
///
class Card {
  final int id;
  final int boardId;
  final String cardTitle;
  final String description;
  final int position;
  final int createdBy;
  final String createdAt;
  final String dueDate;
  final String status;
  final String priority;
  final String estimatedHours;
  final String actualHours;
  final User creator;
  final Board board;
  final List<Assignment> assignments;
  final List<Subtask> subtasks;
  final List<Comment> comments;

  const Card({
    required this.id,
    required this.boardId,
    required this.cardTitle,
    required this.description,
    required this.position,
    required this.createdBy,
    required this.createdAt,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.estimatedHours,
    required this.actualHours,
    required this.creator,
    required this.board,
    required this.assignments,
    required this.subtasks,
    required this.comments,
  });
}
