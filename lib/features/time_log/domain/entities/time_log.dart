/// Entity TimeLog untuk domain layer
///
/// Entity ini merepresentasikan data time log dalam bentuk murni tanpa
/// bergantung pada framework atau library eksternal. Entity ini digunakan
/// di domain layer dan presentation layer untuk business logic.
///
/// Properties:
/// - id: ID unik time log dari database
/// - cardId: ID card yang sedang dikerjakan (nullable)
/// - cardTitle: Judul card untuk ditampilkan (nullable)
/// - boardName: Nama board tempat card berada (nullable)
/// - subtaskId: ID subtask jika tracking subtask (nullable)
/// - subtaskName: Nama subtask untuk ditampilkan (nullable)
/// - startTime: Waktu mulai tracking dalam DateTime
/// - endTime: Waktu selesai tracking (nullable, diisi saat stop)
/// - description: Deskripsi pekerjaan yang dilakukan (nullable)
/// - durationMinutes: Total durasi dalam menit (nullable, diisi saat stop)
/// - durationFormatted: Durasi dalam format string (nullable, misal "2 jam 30 menit")
class TimeLog {
  final int id;
  final int? cardId;
  final String? cardTitle;
  final String? boardName;
  final int? subtaskId;
  final String? subtaskName;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;
  final int? durationMinutes;
  final String? durationFormatted;

  const TimeLog({
    required this.id,
    this.cardId,
    this.cardTitle,
    this.boardName,
    this.subtaskId,
    this.subtaskName,
    required this.startTime,
    this.endTime,
    this.description,
    this.durationMinutes,
    this.durationFormatted,
  });
}
