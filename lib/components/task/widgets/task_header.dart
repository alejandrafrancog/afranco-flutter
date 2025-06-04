import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/task_image.dart';
import 'package:afranco/components/task/widgets/task_badge.dart';
import 'package:afranco/components/task/widgets/task_overlay.dart';

class TaskHeader extends StatelessWidget {
  final Task task;
  final int index;

  const TaskHeader({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TaskImage(randomIndex: index, height: 100),
        TaskOverlay(isCompleted: task.completada),
        TaskBadge(tipo: task.tipo),
      ],
    );
  }
}