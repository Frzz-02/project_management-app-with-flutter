# Time Tracking Feature - Integration Guide

Panduan untuk mengintegrasikan fitur Time Tracking (Start/Stop Task) ke dalam halaman task.

## Struktur File

```
lib/features/time_log/
├── domain/
│   ├── entities/
│   │   └── time_log.dart
│   ├── repositories/
│   │   └── time_log_repository.dart
│   └── usecases/
│       ├── start_time_log_use_case.dart
│       └── stop_time_log_use_case.dart
├── data/
│   ├── models/
│   │   └── time_log_model.dart
│   ├── datasources/
│   │   └── time_log_remote_data_source.dart
│   └── repositories/
│       └── time_log_repository_impl.dart
└── presentation/
    ├── cubits/
    │   ├── time_log_cubit.dart
    │   └── time_log_state.dart
    └── widgets/
        ├── time_log_dialogs.dart
        └── timer_display_widget.dart
```

## Dependency Injection

TimeLogCubit sudah ditambahkan ke `main.dart`:

```dart
BlocProvider(
  create: (_) => TimeLogCubit(
    startTimeLogUseCase: startTimeLogUseCase,
    stopTimeLogUseCase: stopTimeLogUseCase,
  ),
),
```

## Integrasi ke Task Page

### 1. Import Dependencies

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_cubit.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_state.dart';
import 'package:project_management/features/time_log/presentation/widgets/time_log_dialogs.dart';
import 'package:project_management/features/time_log/presentation/widgets/timer_display_widget.dart';
```

### 2. Tambahkan Timer Display di App Bar

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Tasks'),
      actions: [
        // Timer Display (show saat running)
        BlocBuilder<TimeLogCubit, TimeLogState>(
          builder: (context, timeLogState) {
            if (timeLogState is TimeLogRunning) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: TimerDisplayWidget(
                    elapsedTime: timeLogState.formattedElapsedTime,
                    isRunning: true,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    ),
    body: _buildBody(),
  );
}
```

### 3. Tambahkan Start/Stop Button di Card Item

```dart
Widget _buildCardItem(BuildContext context, Card card) {
  return BlocConsumer<TimeLogCubit, TimeLogState>(
    listener: (context, timeLogState) {
      // Handle error
      if (timeLogState is TimeLogError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(timeLogState.message),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Handle success stop
      else if (timeLogState is TimeLogStopped) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Time log dihentikan: ${timeLogState.timeLog.durationFormatted ?? "N/A"}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    },
    builder: (context, timeLogState) {
      // Check apakah card ini yang sedang running
      final isRunning = timeLogState is TimeLogRunning &&
          timeLogState.timeLog.cardId == card.id;

      return ListTile(
        title: Text(card.title),
        subtitle: Text(card.description ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Start/Stop Button
            if (timeLogState is TimeLogInitial || !isRunning)
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () => _handleStartTimeLog(context, card),
                tooltip: 'Start Task',
              )
            else if (isRunning)
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                onPressed: () => _handleStopTimeLog(
                  context,
                  timeLogState.formattedElapsedTime,
                ),
                tooltip: 'Stop Task',
              ),

            // Edit/Delete buttons (existing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditCardDialog(context, card),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _handleDeleteCard(context, card.id),
            ),
          ],
        ),
      );
    },
  );
}
```

### 4. Handler untuk Start Time Log

```dart
Future<void> _handleStartTimeLog(BuildContext context, Card card) async {
  // Show confirmation dialog
  final result = await showStartTimeLogDialog(
    context: context,
    cardTitle: card.title,
  );

  if (result != null && result['confirmed'] == true) {
    // Start time log via cubit
    if (context.mounted) {
      context.read<TimeLogCubit>().startTimeLog(
            cardId: card.id,
            description: result['description'],
          );
    }
  }
}
```

### 5. Handler untuk Stop Time Log

```dart
Future<void> _handleStopTimeLog(
  BuildContext context,
  String elapsedTime,
) async {
  // Show confirmation dialog
  final result = await showStopTimeLogDialog(
    context: context,
    elapsedTime: elapsedTime,
  );

  if (result != null && result['confirmed'] == true) {
    // Stop time log via cubit
    if (context.mounted) {
      context.read<TimeLogCubit>().stopTimeLog(
            description: result['description'],
          );
    }
  }
}
```

## API Endpoints

### Start Time Log
**POST** `/v1/time-logs/start`

Request:
```json
{
  "card_id": 123,
  "description": "Working on bug fix"
}
```

Response:
```json
{
  "success": true,
  "message": "Time log started successfully",
  "data": {
    "id": 789,
    "card_id": 123,
    "card_title": "Fix bug",
    "board_name": "Development",
    "start_time": "2024-01-20T10:00:00Z",
    "end_time": null,
    "description": "Working on bug fix",
    "duration_minutes": null,
    "duration_formatted": null
  }
}
```

### Stop Time Log
**POST** `/v1/time-logs/{id}/stop`

Request:
```json
{
  "description": "Bug fixed successfully"
}
```

Response:
```json
{
  "success": true,
  "message": "Time log stopped successfully",
  "data": {
    "id": 789,
    "card_id": 123,
    "card_title": "Fix bug",
    "board_name": "Development",
    "start_time": "2024-01-20T10:00:00Z",
    "end_time": "2024-01-20T11:30:00Z",
    "description": "Bug fixed successfully",
    "duration_minutes": 90,
    "duration_formatted": "1h 30m"
  }
}
```

## States

### TimeLogInitial
State awal, tidak ada time log yang berjalan. User bisa klik "Start Task".

### TimeLogStarting
Sedang request ke API untuk start. Menampilkan loading indicator.

### TimeLogRunning
Time log sedang berjalan. Timer update setiap detik:
```dart
timeLogState.formattedElapsedTime // "00:01:35"
timeLogState.elapsedSeconds // 95
```

### TimeLogStopping
Sedang request ke API untuk stop. Menampilkan loading indicator.

### TimeLogStopped
Berhasil stop time log. Akan otomatis kembali ke Initial setelah 2 detik.

### TimeLogError
Terjadi error. Menampilkan pesan error yang readable.

## Features

✅ **Confirmation Dialogs** - Dialog konfirmasi sebelum start/stop dengan input deskripsi optional
✅ **Timer Display** - Real-time timer HH:MM:SS dengan blinking indicator
✅ **Auto Token Injection** - AuthInterceptor otomatis inject Bearer token
✅ **Error Handling** - Error dari Dio di-convert ke pesan readable
✅ **Loading States** - Loading indicator saat request API
✅ **Success Feedback** - SnackBar dengan durasi saat berhasil stop
✅ **Clean Architecture** - Domain/Data/Presentation layers terpisah

## Notes

- Hanya satu time log yang bisa berjalan per user
- Timer update setiap 1 detik di client (internal timer di cubit)
- Durasi dihitung di server saat stop
- Bisa start time log untuk card atau subtask (minimal salah satu)
- Description optional untuk start dan stop