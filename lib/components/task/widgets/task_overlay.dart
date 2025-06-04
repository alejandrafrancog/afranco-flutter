import 'package:flutter/material.dart';

class TaskOverlay extends StatelessWidget {
  final bool isCompleted;

  const TaskOverlay({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCompleted) return const SizedBox.shrink();

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(178),
      ),
      child: const Center(
        child: Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}