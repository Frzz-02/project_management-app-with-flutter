import 'package:flutter/material.dart';
import 'package:project_management/features/card/domain/entities/card.dart'
    as entity;
import 'package:project_management/core/utils/date_formatter.dart';

/// Model untuk subtask (dummy data)
class Subtask {
  final String id;
  final String title;
  final bool isCompleted;
  final String? assignee;
  final String priority;
  final String? dueDate;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.assignee,
    this.priority = 'medium',
    this.dueDate,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? assignee,
    String? priority,
    String? dueDate,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      assignee: assignee ?? this.assignee,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

/// Halaman Subtask dengan desain mirip Jira
class SubtaskPage extends StatefulWidget {
  final entity.Card card;

  const SubtaskPage({super.key, required this.card});

  @override
  State<SubtaskPage> createState() => _SubtaskPageState();
}

class _SubtaskPageState extends State<SubtaskPage> {
  // Dummy data subtasks
  List<Subtask> subtasks = [
    Subtask(
      id: '1',
      title: 'Design database schema',
      isCompleted: true,
      assignee: 'John Doe',
      priority: 'high',
      dueDate: '2024-11-10',
    ),
    Subtask(
      id: '2',
      title: 'Create API endpoints',
      isCompleted: true,
      assignee: 'Jane Smith',
      priority: 'high',
      dueDate: '2024-11-12',
    ),
    Subtask(
      id: '3',
      title: 'Implement authentication',
      isCompleted: false,
      assignee: 'Mike Johnson',
      priority: 'high',
      dueDate: '2024-11-15',
    ),
    Subtask(
      id: '4',
      title: 'Write unit tests',
      isCompleted: false,
      assignee: null,
      priority: 'medium',
      dueDate: '2024-11-18',
    ),
    Subtask(
      id: '5',
      title: 'Update documentation',
      isCompleted: false,
      assignee: null,
      priority: 'low',
      dueDate: null,
    ),
  ];

  final TextEditingController _newSubtaskController = TextEditingController();

  @override
  void dispose() {
    _newSubtaskController.dispose();
    super.dispose();
  }

  // Calculate progress
  double get progress {
    if (subtasks.isEmpty) return 0.0;
    final completed = subtasks.where((s) => s.isCompleted).length;
    return completed / subtasks.length;
  }

  void _toggleSubtask(String id) {
    setState(() {
      final index = subtasks.indexWhere((s) => s.id == id);
      if (index != -1) {
        subtasks[index] = subtasks[index].copyWith(
          isCompleted: !subtasks[index].isCompleted,
        );
      }
    });
  }

  void _addSubtask() {
    if (_newSubtaskController.text.trim().isEmpty) return;

    setState(() {
      subtasks.add(
        Subtask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _newSubtaskController.text.trim(),
          isCompleted: false,
          priority: 'medium',
        ),
      );
      _newSubtaskController.clear();
    });
  }

  void _deleteSubtask(String id) {
    setState(() {
      subtasks.removeWhere((s) => s.id == id);
    });
  }

  void _showEditDialog(Subtask subtask) {
    final controller = TextEditingController(text: subtask.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Subtask title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  final index = subtasks.indexWhere((s) => s.id == subtask.id);
                  if (index != -1) {
                    subtasks[index] = subtasks[index].copyWith(
                      title: controller.text.trim(),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    final totalCount = subtasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF172B4D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.card.cardTitle,
              style: const TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.card.board.project.projectName} / ${widget.card.board.boardName}',
              style: const TextStyle(
                color: Color(0xFF5E6C84),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFDFE1E6), height: 1),
        ),
      ),
      body: Column(
        children: [
          // Progress section (Jira-style)
          _buildProgressSection(completedCount, totalCount),

          // Subtasks list
          Expanded(
            child: subtasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: subtasks.length,
                    itemBuilder: (context, index) {
                      return _buildSubtaskItem(subtasks[index]);
                    },
                  ),
          ),

          // Add new subtask section
          _buildAddSubtaskSection(),
        ],
      ),
    );
  }

  /// Progress section mirip Jira
  Widget _buildProgressSection(int completed, int total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5E6C84),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '$completed of $total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172B4D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFDFE1E6),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0
                    ? const Color(0xFF00875A)
                    : const Color(0xFF0052CC),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: const TextStyle(fontSize: 12, color: Color(0xFF5E6C84)),
          ),
        ],
      ),
    );
  }

  /// Subtask item mirip Jira
  Widget _buildSubtaskItem(Subtask subtask) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFDFE1E6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSubtask(subtask.id),
          borderRadius: BorderRadius.circular(3),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => _toggleSubtask(subtask.id),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: subtask.isCompleted
                          ? const Color(0xFF0052CC)
                          : Colors.white,
                      border: Border.all(
                        color: subtask.isCompleted
                            ? const Color(0xFF0052CC)
                            : const Color(0xFFDFE1E6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: subtask.isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtask.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF172B4D),
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: const Color(0xFF5E6C84),
                        ),
                      ),
                      if (subtask.assignee != null || subtask.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (subtask.assignee != null)
                                _buildInfoChip(
                                  icon: Icons.person_outline,
                                  label: subtask.assignee!,
                                  color: const Color(0xFF5E6C84),
                                ),
                              if (subtask.dueDate != null)
                                _buildInfoChip(
                                  icon: Icons.calendar_today,
                                  label: DateFormatter.formatDateWithMonth(
                                    subtask.dueDate!,
                                  ),
                                  color:
                                      DateFormatter.isOverdue(subtask.dueDate!)
                                      ? const Color(0xFFDE350B)
                                      : const Color(0xFF5E6C84),
                                ),
                              _buildPriorityChip(subtask.priority),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF5E6C84),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Color(0xFF5E6C84)),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 18,
                            color: Color(0xFFDE350B),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: Color(0xFFDE350B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(subtask);
                    } else if (value == 'delete') {
                      _deleteSubtask(subtask.id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Info chip helper
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Priority chip
  Widget _buildPriorityChip(String priority) {
    Color color;
    IconData icon;

    switch (priority.toLowerCase()) {
      case 'high':
        color = const Color(0xFFDE350B);
        icon = Icons.keyboard_arrow_up;
        break;
      case 'low':
        color = const Color(0xFF00875A);
        icon = Icons.keyboard_arrow_down;
        break;
      default:
        color = const Color(0xFFFF991F);
        icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 80,
            color: const Color(0xFFDFE1E6),
          ),
          const SizedBox(height: 16),
          const Text(
            'No subtasks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5E6C84),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Break down this task into smaller pieces',
            style: TextStyle(fontSize: 14, color: Color(0xFF8993A4)),
          ),
        ],
      ),
    );
  }

  /// Add subtask section (Jira-style)
  Widget _buildAddSubtaskSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFDFE1E6), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newSubtaskController,
                decoration: InputDecoration(
                  hintText: 'Add a subtask...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF8993A4),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.add,
                    color: Color(0xFF5E6C84),
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color(0xFFDFE1E6),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color(0xFFDFE1E6),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color(0xFF0052CC),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _addSubtask(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addSubtask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
