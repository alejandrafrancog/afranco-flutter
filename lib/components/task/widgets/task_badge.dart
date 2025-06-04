import 'package:flutter/material.dart';

class TaskBadge extends StatelessWidget {
  final String tipo;

  const TaskBadge({
    super.key,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = tipo == 'urgente';
    
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isUrgent 
              ? Colors.red.withAlpha(230)
              : Colors.blue.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUrgent ? Icons.warning : Icons.task,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              isUrgent ? 'URGENTE' : 'NORMAL',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}