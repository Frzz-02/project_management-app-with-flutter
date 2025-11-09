import 'task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  const TaskRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
