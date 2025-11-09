/// Comment Entity
///
/// Entity untuk representasi data comment di domain layer
/// Comment adalah komentar yang diberikan pada card tertentu
///
class Comment {
  final int id;
  final int cardId;
  final int userId;
  final String commentText;
  final String createdAt;

  const Comment({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.commentText,
    required this.createdAt,
  });
}
