import '../../domain/entities/time_log.dart';

/// Model untuk Time Log
///
/// Model ini merupakan representasi data dari API response/request.
/// Model extends entity agar bisa digunakan di domain layer.
/// Model bertanggung jawab untuk serialization dan deserialization JSON.
///
/// Perbedaan Model vs Entity:
/// - Entity: Pure business object, tidak tahu tentang JSON
/// - Model: Tahu cara convert dari/ke JSON, extends Entity
class TimeLogModel extends TimeLog {
  TimeLogModel({
    required int id,
    int? cardId,
    String? cardTitle,
    String? boardName,
    int? subtaskId,
    String? subtaskName,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    int? durationMinutes,
    String? durationFormatted,
  }) : super(
         id: id,
         cardId: cardId,
         cardTitle: cardTitle,
         boardName: boardName,
         subtaskId: subtaskId,
         subtaskName: subtaskName,
         startTime: startTime,
         endTime: endTime,
         description: description,
         durationMinutes: durationMinutes,
         durationFormatted: durationFormatted,
       );

  /// Factory constructor untuk membuat TimeLogModel dari JSON
  ///
  /// Method ini digunakan untuk parsing response dari API.
  /// Menggunakan null safety (?? '') untuk menghindari error parsing.
  /// DateTime di-parse dari string ISO 8601 format.
  ///
  /// Parameter:
  /// - json: Map<String, dynamic> dari response API
  ///
  /// Returns: TimeLogModel instance
  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] as int? ?? 0,
      cardId: json['card_id'] as int?,
      cardTitle: json['card_title'] as String?,
      boardName: json['board_name'] as String?,
      subtaskId: json['subtask_id'] as int?,
      subtaskName: json['subtask_name'] as String?,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      description: json['description'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      durationFormatted: json['duration_formatted'] as String?,
    );
  }

  /// Method untuk convert TimeLogModel ke JSON
  ///
  /// Method ini digunakan untuk membuat request body ke API.
  /// Hanya mengirim field yang diperlukan oleh API.
  /// DateTime di-convert ke string ISO 8601 format.
  ///
  /// Returns: Map<String, dynamic> untuk request body
  Map<String, dynamic> toJson() {
    return {
      if (cardId != null) 'card_id': cardId,
      if (subtaskId != null) 'subtask_id': subtaskId,
      if (description != null && description!.isNotEmpty)
        'description': description,
      // start_time dan end_time biasanya di-handle oleh API
      // jadi tidak perlu dikirim dari client
    };
  }
}
