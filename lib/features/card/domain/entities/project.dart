/// Project Entity
///
/// Entity untuk representasi data project di domain layer
/// Setiap board terkait dengan satu project
///
class Project {
  final int id;
  final String projectName;
  final String description;
  final int createdBy;
  final String deadline;
  final String createdAt;

  const Project({
    required this.id,
    required this.projectName,
    required this.description,
    required this.createdBy,
    required this.deadline,
    required this.createdAt,
  });
}
