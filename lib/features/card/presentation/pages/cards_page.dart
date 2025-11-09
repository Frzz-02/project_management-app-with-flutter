import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/card/presentation/cubits/card_cubit.dart';
import 'package:project_management/features/card/presentation/cubits/card_state.dart';

/// Cards Page
///
/// Halaman untuk menampilkan semua cards dari API
/// Menggunakan BlocBuilder untuk reactive UI berdasarkan state
///
class CardsPage extends StatefulWidget {
  static const String routeName = '/cards';

  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch cards saat halaman pertama kali dibuka
    context.read<CardCubit>().fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Tombol refresh untuk fetch ulang data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CardCubit>().refreshCards();
            },
          ),
        ],
      ),
      body: BlocBuilder<CardCubit, CardState>(
        builder: (context, state) {
          // Handle berbagai state menggunakan pattern matching
          return switch (state) {
            // State Initial: tampilkan pesan awal
            CardInitial() => const Center(
              child: Text(
                'Tekan tombol refresh untuk memuat cards',
                style: TextStyle(fontSize: 16),
              ),
            ),

            // State Loading: tampilkan loading indicator
            CardLoading() => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat cards...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            // State Loaded: tampilkan list cards
            CardLoaded(:final cards) =>
              cards.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada cards',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context.read<CardCubit>().refreshCards();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Card Title
                                  Text(
                                    card.cardTitle,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    card.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Status, Priority, Due Date
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildChip(
                                        label: card.status.toUpperCase(),
                                        color: _getStatusColor(card.status),
                                      ),
                                      _buildChip(
                                        label: card.priority.toUpperCase(),
                                        color: _getPriorityColor(card.priority),
                                      ),
                                      _buildChip(
                                        label:
                                            'Due: ${_formatDate(card.dueDate)}',
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Board and Project Info
                                  Text(
                                    '📋 ${card.board.boardName} - ${card.board.project.projectName}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Creator Info
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Created by: ${card.creator.fullName}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Assignments Count
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.group,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${card.assignments.length} assigned',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.list_alt,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${card.subtasks.length} subtasks',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

            // State Error: tampilkan error message
            CardError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CardCubit>().refreshCards();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }

  /// Helper method untuk membuat chip label
  ///
  /// [label] adalah text yang ditampilkan
  /// [color] adalah warna background chip
  ///
  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  /// Helper method untuk get color berdasarkan status
  ///
  /// [status] adalah status card (todo, in_progress, done, etc)
  /// Returns Color yang sesuai dengan status
  ///
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'done':
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Helper method untuk get color berdasarkan priority
  ///
  /// [priority] adalah priority card (low, medium, high)
  /// Returns Color yang sesuai dengan priority
  ///
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Helper method untuk format date
  ///
  /// [dateString] adalah string date dalam format ISO 8601
  /// Returns formatted date string (DD/MM/YYYY)
  ///
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
