// components/task_image.dart
import 'package:flutter/material.dart';

class TaskImage extends StatelessWidget {
  final int randomIndex;
  final double height;

  const TaskImage({
    Key? key,
    required this.randomIndex,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        'https://picsum.photos/200/300?random=$randomIndex',
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      ),
    );
  }
}
