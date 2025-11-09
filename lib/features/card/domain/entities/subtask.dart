/// Subtask Entity
///
/// Entity untuk representasi data subtask di domain layer
/// Subtask adalah tugas kecil yang merupakan bagian dari card utama
///
class Subtask {
  final int id;
  final int cardId;
  final String subtaskTitle;
  final String? description;
  final String status;
  final int position;
  final String createdAt;

  const Subtask({
    required this.id,
    required this.cardId,
    required this.subtaskTitle,
    this.description,
    required this.status,
    required this.position,
    required this.createdAt,
  });
}
