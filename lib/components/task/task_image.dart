import 'package:flutter/material.dart';

class TaskImage extends StatelessWidget {
  final int randomIndex;
  final double height;

  const TaskImage({
    super.key,
    required this.randomIndex,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        'https://picsum.photos/200/300?random=$randomIndex',
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      ),
    );
  }
}
