import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
