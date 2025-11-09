import 'package:flutter/material.dart';

/// Widget untuk menampilkan timer yang sedang berjalan
///
/// Widget ini menampilkan elapsed time dalam format HH:MM:SS
/// dengan animasi pulse untuk indikasi timer sedang berjalan.
///
/// Parameter:
/// - elapsedTime: String dalam format "HH:MM:SS"
/// - isRunning: Boolean untuk indikasi timer sedang berjalan (untuk animasi)
class TimerDisplayWidget extends StatelessWidget {
  final String elapsedTime;
  final bool isRunning;

  const TimerDisplayWidget({
    super.key,
    required this.elapsedTime,
    this.isRunning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isRunning ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRunning ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon indikator
          if (isRunning)
            Icon(Icons.timer, color: Colors.green.shade700, size: 20)
          else
            Icon(Icons.timer_off, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),

          // Elapsed time text
          Text(
            elapsedTime,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: isRunning ? Colors.green.shade900 : Colors.grey.shade700,
            ),
          ),

          // Blinking dot untuk running indicator
          if (isRunning) ...[const SizedBox(width: 8), _BlinkingDot()],
        ],
      ),
    );
  }
}

/// Widget dot yang berkedip untuk indikasi timer running
///
/// Menggunakan AnimatedOpacity untuk efek blink.
/// Internal widget, hanya dipakai di TimerDisplayWidget.
class _BlinkingDot extends StatefulWidget {
  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
