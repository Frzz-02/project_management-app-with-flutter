import 'package:project_management/features/card/data/models/assignment_model.dart';
import 'package:project_management/features/card/data/models/board_model.dart';
import 'package:project_management/features/card/data/models/comment_model.dart';
import 'package:project_management/features/card/data/models/subtask_model.dart';
import 'package:project_management/features/card/data/models/user_model.dart';
import '../../domain/entities/card.dart' as entity;

/// Card Model
///
/// Model utama untuk mapping data card dari/ke JSON
/// Extends dari Card entity dan menambahkan factory method untuk parsing
///
class CardModel extends entity.Card {
  const CardModel({
    required super.id,
    required super.boardId,
    required super.cardTitle,
    required super.description,
    required super.position,
    required super.createdBy,
    required super.createdAt,
    required super.dueDate,
    required super.status,
    required super.priority,
    required super.estimatedHours,
    required super.actualHours,
    required super.creator,
    required super.board,
    required super.assignments,
    required super.subtasks,
    required super.comments,
  });

  /// Factory method untuk membuat CardModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data card dari API response
  /// Returns CardModel instance dengan semua nested models
  ///
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as int,
      boardId: json['board_id'] as int? ?? 0,
      cardTitle: json['card_title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      createdBy: json['created_by'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      dueDate: json['due_date'] as String? ?? '',
      status: json['status'] as String? ?? 'todo',
      priority: json['priority'] as String? ?? 'medium',
      estimatedHours: json['estimated_hours'] as String? ?? '0',
      actualHours: json['actual_hours'] as String? ?? '0',
      creator: UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      board: BoardModel.fromJson(json['board'] as Map<String, dynamic>),
      assignments:
          (json['assignments'] as List<dynamic>?)
              ?.map(
                (assignment) => AssignmentModel.fromJson(
                  assignment as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      subtasks:
          (json['subtasks'] as List<dynamic>?)
              ?.map(
                (subtask) =>
                    SubtaskModel.fromJson(subtask as Map<String, dynamic>),
              )
              .toList() ??
          [],
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map(
                (comment) =>
                    CommentModel.fromJson(comment as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  /// Method untuk convert CardModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'board_id': boardId,
      'card_title': cardTitle,
      'description': description,
      'position': position,
      'created_by': createdBy,
      'created_at': createdAt,
      'due_date': dueDate,
      'status': status,
      'priority': priority,
      'estimated_hours': estimatedHours,
      'actual_hours': actualHours,
      'creator': (creator as UserModel).toJson(),
      'board': (board as BoardModel).toJson(),
      'assignments': assignments
          .map((assignment) => (assignment as AssignmentModel).toJson())
          .toList(),
      'subtasks': subtasks
          .map((subtask) => (subtask as SubtaskModel).toJson())
          .toList(),
      'comments': comments
          .map((comment) => (comment as CommentModel).toJson())
          .toList(),
    };
  }
}
