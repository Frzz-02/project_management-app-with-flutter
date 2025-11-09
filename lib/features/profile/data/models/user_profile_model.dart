



/// Model untuk data profil pengguna yang diterima dari API /api/v1/me
/// 
/// Model ini merepresentasikan struktur data profil pengguna lengkap
/// termasuk informasi pribadi, proyek, kartu tugas, komentar, dan time logs
class UserProfileModel {
  final int id;
  final String username;
  final String fullName;
  final String currentTaskStatus;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final String createdAt;
  final List<ProjectModel> createdProjects;
  final List<ProjectMembershipModel> projectMemberships;
  final List<CardModel> createdCards;
  final List<CommentModel> comments;
  final List<TimeLogModel> timeLogs;



  /// Constructor untuk UserProfileModel
  UserProfileModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.currentTaskStatus,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.createdProjects,
    required this.projectMemberships,
    required this.createdCards,
    required this.comments,
    required this.timeLogs,
  });



  /// Factory constructor untuk membuat UserProfileModel dari JSON
  /// 
  /// [json] Map yang berisi data JSON dari API response
  /// Returns UserProfileModel instance dengan data yang sudah diparsing
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      currentTaskStatus: json['current_task_status'] ?? 'idle',
      email: json['email'] ?? '',
      role: json['role'] ?? 'member',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      createdProjects: (json['created_projects'] as List<dynamic>?)
              ?.map((e) => ProjectModel.fromJson(e))
              .toList() ??
          [],
      projectMemberships: (json['project_memberships'] as List<dynamic>?)
              ?.map((e) => ProjectMembershipModel.fromJson(e))
              .toList() ??
          [],
      createdCards: (json['created_cards'] as List<dynamic>?)
              ?.map((e) => CardModel.fromJson(e))
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e))
              .toList() ??
          [],
      timeLogs: (json['time_logs'] as List<dynamic>?)
              ?.map((e) => TimeLogModel.fromJson(e))
              .toList() ??
          [],
    );
  }



  /// Method untuk convert UserProfileModel ke JSON
  /// 
  /// Returns Map berisi data model dalam format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'current_task_status': currentTaskStatus,
      'email': email,
      'role': role,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'created_projects': createdProjects.map((e) => e.toJson()).toList(),
      'project_memberships':
          projectMemberships.map((e) => e.toJson()).toList(),
      'created_cards': createdCards.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'time_logs': timeLogs.map((e) => e.toJson()).toList(),
    };
  }
}




/// Model untuk statistik profil pengguna
/// 
/// Berisi ringkasan total komentar, time logs, dan jam kerja yang tercatat
class ProfileStatsModel {
  final int totalComments;
  final int totalTimeLogs;
  final double totalHoursTracked;



  /// Constructor untuk ProfileStatsModel
  ProfileStatsModel({
    required this.totalComments,
    required this.totalTimeLogs,
    required this.totalHoursTracked,
  });



  /// Factory constructor untuk membuat ProfileStatsModel dari JSON
  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) {
    return ProfileStatsModel(
      totalComments: json['total_comments'] ?? 0,
      totalTimeLogs: json['total_time_logs'] ?? 0,
      totalHoursTracked: (json['total_hours_tracked'] ?? 0).toDouble(),
    );
  }



  /// Method untuk convert ProfileStatsModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'total_comments': totalComments,
      'total_time_logs': totalTimeLogs,
      'total_hours_tracked': totalHoursTracked,
    };
  }
}




/// Model untuk data proyek
class ProjectModel {
  final int id;
  final String projectName;
  final String description;
  final int createdBy;
  final String deadline;
  final String createdAt;



  ProjectModel({
    required this.id,
    required this.projectName,
    required this.description,
    required this.createdBy,
    required this.deadline,
    required this.createdAt,
  });



  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      projectName: json['project_name'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['created_by'] ?? 0,
      deadline: json['deadline'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }



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




/// Model untuk membership proyek pengguna
class ProjectMembershipModel {
  final int id;
  final int projectId;
  final int userId;
  final String role;
  final String joinedAt;
  final ProjectModel? project;



  ProjectMembershipModel({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.project,
  });



  factory ProjectMembershipModel.fromJson(Map<String, dynamic> json) {
    return ProjectMembershipModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      role: json['role'] ?? '',
      joinedAt: json['joined_at'] ?? '',
      project: json['project'] != null
          ? ProjectModel.fromJson(json['project'])
          : null,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'user_id': userId,
      'role': role,
      'joined_at': joinedAt,
      'project': project?.toJson(),
    };
  }
}




/// Model untuk data kartu tugas
class CardModel {
  final int id;
  final int boardId;
  final String cardTitle;
  final String description;
  final int position;
  final int createdBy;
  final String createdAt;
  final String? dueDate;
  final String status;
  final String priority;
  final String estimatedHours;
  final String actualHours;
  final BoardModel? board;



  CardModel({
    required this.id,
    required this.boardId,
    required this.cardTitle,
    required this.description,
    required this.position,
    required this.createdBy,
    required this.createdAt,
    this.dueDate,
    required this.status,
    required this.priority,
    required this.estimatedHours,
    required this.actualHours,
    this.board,
  });



  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] ?? 0,
      boardId: json['board_id'] ?? 0,
      cardTitle: json['card_title'] ?? '',
      description: json['description'] ?? '',
      position: json['position'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      dueDate: json['due_date'],
      status: json['status'] ?? '',
      priority: json['priority'] ?? 'medium',
      estimatedHours: json['estimated_hours']?.toString() ?? '0',
      actualHours: json['actual_hours']?.toString() ?? '0',
      board: json['board'] != null ? BoardModel.fromJson(json['board']) : null,
    );
  }



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
      'board': board?.toJson(),
    };
  }
}




/// Model untuk data board
class BoardModel {
  final int id;
  final int projectId;
  final String boardName;
  final String description;
  final int position;
  final String createdAt;



  BoardModel({
    required this.id,
    required this.projectId,
    required this.boardName,
    required this.description,
    required this.position,
    required this.createdAt,
  });



  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      boardName: json['board_name'] ?? '',
      description: json['description'] ?? '',
      position: json['position'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'board_name': boardName,
      'description': description,
      'position': position,
      'created_at': createdAt,
    };
  }
}




/// Model untuk data komentar
class CommentModel {
  final int id;
  final int cardId;
  final int? subtaskId;
  final int userId;
  final String commentText;
  final String commentType;
  final String createdAt;
  final String updatedAt;
  final CardModel? card;



  CommentModel({
    required this.id,
    required this.cardId,
    this.subtaskId,
    required this.userId,
    required this.commentText,
    required this.commentType,
    required this.createdAt,
    required this.updatedAt,
    this.card,
  });



  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      cardId: json['card_id'] ?? 0,
      subtaskId: json['subtask_id'],
      userId: json['user_id'] ?? 0,
      commentText: json['comment_text'] ?? '',
      commentType: json['comment_type'] ?? 'card',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      card: json['card'] != null ? CardModel.fromJson(json['card']) : null,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'subtask_id': subtaskId,
      'user_id': userId,
      'comment_text': commentText,
      'comment_type': commentType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'card': card?.toJson(),
    };
  }
}




/// Model untuk data time log
class TimeLogModel {
  final int id;
  final int cardId;
  final int? subtaskId;
  final int userId;
  final String startTime;
  final String? endTime;
  final int durationMinutes;
  final String? description;
  final CardModel? card;



  TimeLogModel({
    required this.id,
    required this.cardId,
    this.subtaskId,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.durationMinutes,
    this.description,
    this.card,
  });



  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] ?? 0,
      cardId: json['card_id'] ?? 0,
      subtaskId: json['subtask_id'],
      userId: json['user_id'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'],
      durationMinutes: json['duration_minutes'] ?? 0,
      description: json['description'],
      card: json['card'] != null ? CardModel.fromJson(json['card']) : null,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'subtask_id': subtaskId,
      'user_id': userId,
      'start_time': startTime,
      'end_time': endTime,
      'duration_minutes': durationMinutes,
      'description': description,
      'card': card?.toJson(),
    };
  }
}
