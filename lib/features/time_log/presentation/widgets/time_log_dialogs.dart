import 'package:flutter/material.dart';

/// Dialog konfirmasi untuk Start Task
///
/// Dialog ini ditampilkan saat user menekan tombol "Start Task".
/// User bisa input deskripsi apa yang akan dikerjakan (optional).
///
/// Returns:
/// - Map dengan key 'confirmed' (bool) dan 'description' (String?)
/// - null jika user cancel
Future<Map<String, dynamic>?> showStartTimeLogDialog({
  required BuildContext context,
  String? cardTitle,
}) {
  final descriptionController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Mulai Time Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cardTitle != null) ...[
              Text(
                'Task: $cardTitle',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Apakah Anda yakin ingin memulai time tracking untuk task ini?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (Optional)',
                hintText: 'Apa yang akan Anda kerjakan?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(null);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop({
                'confirmed': true,
                'description': descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              });
            },
            child: const Text('Mulai'),
          ),
        ],
      );
    },
  );
}

/// Dialog konfirmasi untuk Stop Task
///
/// Dialog ini ditampilkan saat user menekan tombol "Stop Task".
/// User bisa input deskripsi hasil pekerjaan (optional).
///
/// Returns:
/// - Map dengan key 'confirmed' (bool) dan 'description' (String?)
/// - null jika user cancel
Future<Map<String, dynamic>?> showStopTimeLogDialog({
  required BuildContext context,
  String? elapsedTime,
}) {
  final descriptionController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Hentikan Time Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (elapsedTime != null) ...[
              Text(
                'Waktu berjalan: $elapsedTime',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Apakah Anda yakin ingin menghentikan time tracking?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (Optional)',
                hintText: 'Apa yang sudah Anda kerjakan?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(null);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop({
                'confirmed': true,
                'description': descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hentikan'),
          ),
        ],
      );
    },
  );
}
