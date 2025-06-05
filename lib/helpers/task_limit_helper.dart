// helpers/task_limit_helper.dart
import 'package:flutter/material.dart';

mixin TaskLimitHelper {

  static const int _maxTasksPerUser = 3;
  
  bool hasReachedTaskLimit(int currentTaskCount) {
    return currentTaskCount >= _maxTasksPerUser;
  }
  
  int get maxTasksAllowed => _maxTasksPerUser;
  
  int getRemainingTasks(int currentTaskCount) {
    return _maxTasksPerUser - currentTaskCount;
  }
  
  /// Muestra un diálogo de límite alcanzado
  void showTaskLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Límite Alcanzado ⚠️ ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Has alcanzado el límite máximo de $_maxTasksPerUser tareas.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Elimina una tarea existente para poder agregar una nueva.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Entendido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Muestra un SnackBar de límite alcanzado (alternativa más sutil)
  void showTaskLimitSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '⚠️ Límite de tareas alcanzado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Máximo $_maxTasksPerUser tareas permitidas. Elimina una para continuar.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  bool canAddTask(BuildContext context, int currentTaskCount, {bool showDialog = true}) {
    if (hasReachedTaskLimit(currentTaskCount)) {
      if (showDialog) {
        showTaskLimitDialog(context);
      }
      return false;
    }
    return true;
  }
  
  String getTaskLimitMessage(int currentTaskCount) {
    if (hasReachedTaskLimit(currentTaskCount)) {
      return 'Límite alcanzado ($_maxTasksPerUser/$_maxTasksPerUser)';
    } else {
      int remaining = getRemainingTasks(currentTaskCount);
      return 'Tareas restantes: $remaining';
    }
  }
}