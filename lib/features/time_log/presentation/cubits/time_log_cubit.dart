import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/start_time_log_use_case.dart';
import '../../domain/usecases/stop_time_log_use_case.dart';
import 'time_log_state.dart';

/// Cubit untuk Time Log
///
/// Cubit ini mengelola state time tracking (start/stop).
/// Menggunakan Timer.periodic untuk update elapsed seconds setiap detik.
///
/// Flow:
/// 1. User klik "Start Task" -> emit Starting -> call API -> emit Running
/// 2. Timer.periodic mulai berjalan, update elapsedSeconds setiap 1 detik
/// 3. User klik "Stop Task" -> emit Stopping -> call API -> emit Stopped -> kembali Initial
///
/// Kenapa pakai Cubit bukan Bloc?
/// - Lebih simple, tidak perlu event class
/// - Cocok untuk simple state management seperti timer
/// - Sesuai permintaan user
class TimeLogCubit extends Cubit<TimeLogState> {
  final StartTimeLogUseCase startTimeLogUseCase;
  final StopTimeLogUseCase stopTimeLogUseCase;

  // Timer untuk update elapsed seconds
  Timer? _timer;

  TimeLogCubit({
    required this.startTimeLogUseCase,
    required this.stopTimeLogUseCase,
  }) : super(const TimeLogInitial());

  /// Memulai time log
  ///
  /// Method ini akan:
  /// 1. Emit state Starting (loading indicator)
  /// 2. Call use case untuk start time log via API
  /// 3. Jika berhasil: emit Running dan mulai timer
  /// 4. Jika gagal: emit Error dengan pesan error
  ///
  /// Parameter:
  /// - cardId: ID card yang akan ditracking (nullable)
  /// - subtaskId: ID subtask yang akan ditracking (nullable)
  /// - description: Deskripsi pekerjaan (optional)
  Future<void> startTimeLog({
    int? cardId,
    int? subtaskId,
    String? description,
  }) async {
    try {
      // Emit loading state
      emit(const TimeLogStarting());

      // Call use case
      final timeLog = await startTimeLogUseCase(
        cardId: cardId,
        subtaskId: subtaskId,
        description: description,
      );

      // Emit running state dengan elapsed seconds = 0
      emit(TimeLogRunning(timeLog: timeLog, elapsedSeconds: 0));

      // Mulai timer untuk update elapsed seconds setiap detik
      _startTimer();
    } catch (e) {
      // Handle error
      emit(TimeLogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Menghentikan time log
  ///
  /// Method ini akan:
  /// 1. Stop timer terlebih dahulu
  /// 2. Emit state Stopping (loading indicator)
  /// 3. Call use case untuk stop time log via API
  /// 4. Jika berhasil: emit Stopped -> kembali ke Initial setelah delay
  /// 5. Jika gagal: emit Error dengan pesan error
  ///
  /// Parameter:
  /// - description: Deskripsi hasil pekerjaan (optional)
  Future<void> stopTimeLog({String? description}) async {
    // Get current state untuk ambil timeLogId
    final currentState = state;
    if (currentState is! TimeLogRunning) {
      emit(const TimeLogError('Tidak ada time log yang sedang berjalan'));
      return;
    }

    try {
      // Stop timer terlebih dahulu
      _stopTimer();

      // Emit loading state
      emit(const TimeLogStopping());

      // Call use case
      final timeLog = await stopTimeLogUseCase(
        currentState.timeLog.id,
        description: description,
      );

      // Emit stopped state
      emit(TimeLogStopped(timeLog));

      // Kembali ke initial setelah 2 detik (agar user sempat lihat hasilnya)
      await Future.delayed(const Duration(seconds: 2));
      emit(const TimeLogInitial());
    } catch (e) {
      // Handle error
      emit(TimeLogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Reset ke state initial
  ///
  /// Method ini untuk reset state jika terjadi error
  /// atau user ingin cancel action.
  void reset() {
    _stopTimer();
    emit(const TimeLogInitial());
  }

  /// Mulai timer untuk update elapsed seconds
  ///
  /// Timer akan berjalan setiap 1 detik dan emit state Running
  /// dengan elapsedSeconds yang di-increment.
  ///
  /// Internal method, dipanggil otomatis saat start time log.
  void _startTimer() {
    _timer?.cancel(); // Cancel timer lama jika ada
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is TimeLogRunning) {
        // Emit state baru dengan elapsedSeconds + 1
        emit(
          TimeLogRunning(
            timeLog: currentState.timeLog,
            elapsedSeconds: currentState.elapsedSeconds + 1,
          ),
        );
      } else {
        // Jika state sudah bukan Running, stop timer
        timer.cancel();
      }
    });
  }

  /// Stop timer
  ///
  /// Method untuk stop timer saat time log dihentikan atau di-reset.
  /// Internal method.
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Clean up timer saat cubit di-dispose
  ///
  /// Override close() untuk memastikan timer di-cancel
  /// agar tidak ada memory leak.
  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
