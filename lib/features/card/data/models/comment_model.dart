import '../../domain/entities/comment.dart';

/// Comment Model
///
/// Model untuk mapping data comment dari/ke JSON
/// Extends dari Comment entity dan menambahkan factory method untuk parsing
///
class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.cardId,
    required super.userId,
    required super.commentText,
    required super.createdAt,
  });

  /// Factory method untuk membuat CommentModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data comment dari API response
  /// Returns CommentModel instance
  ///
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      cardId: json['card_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      commentText: json['comment_text'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Method untuk convert CommentModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'user_id': userId,
      'comment_text': commentText,
      'created_at': createdAt,
    };
  }
}
