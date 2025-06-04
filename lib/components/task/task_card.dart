import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/constants/constants.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono con contenedor estilizado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: task.tipo == 'urgente' 
                      ? Colors.red.withAlpha(25)
                      : Colors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.tipo == 'urgente' 
                        ? Colors.red.withAlpha(76)
                        : Colors.blue.withAlpha(76),
                    width: 1,
                  ),
                ),
                child: Icon(
                  task.tipo == 'urgente' ? Icons.warning_rounded : Icons.task_rounded,
                  color: task.tipo == 'urgente' ? Colors.red.shade700 : Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Contenido de texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la tarea
                    Text(
                      task.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Tipo de tarea con badge
                    Row(
                      children: [
                        Text(
                          '${AppConstantes.taskTypeLabel}:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: task.tipo == 'urgente' 
                                ? Colors.red.withAlpha(230)
                                : Colors.blue.withAlpha(230),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.tipo.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Indicador de estado
              if (task.completada)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withAlpha(76),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}