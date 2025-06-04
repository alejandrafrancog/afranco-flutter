import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDeadline extends StatelessWidget {
  final DateTime fechaLimite;

  const TaskDeadline({
    super.key,
    required this.fechaLimite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _getFechaLimiteColor(fechaLimite).withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getFechaLimiteColor(fechaLimite).withAlpha(76),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: _getFechaLimiteColor(fechaLimite),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('dd/MM/yyyy').format(fechaLimite),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _getFechaLimiteColor(fechaLimite),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getFechaLimiteText(fechaLimite),
            style: TextStyle(
              fontSize: 11,
              color: _getFechaLimiteColor(fechaLimite),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getFechaLimiteColor(DateTime fechaLimite) {
    final now = DateTime.now();
    final difference = fechaLimite.difference(now).inDays;
    
    if (difference < 0) return Colors.red; // Vencida
    if (difference <= 1) return Colors.orange; // Próxima a vencer
    if (difference <= 7) return Colors.amber; // Esta semana
    return Colors.green; // A tiempo
  }

  String _getFechaLimiteText(DateTime fechaLimite) {
    final now = DateTime.now();
    final difference = fechaLimite.difference(now).inDays;
    
    if (difference < 0) return 'VENCIDA';
    if (difference == 0) return 'HOY';
    if (difference == 1) return 'MAÑANA';
    if (difference <= 7) return 'ESTA SEMANA';
    return 'A TIEMPO';
  }
}