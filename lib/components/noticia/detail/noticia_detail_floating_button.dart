import 'package:flutter/material.dart';

class NoticiaDetailFloatingButton extends StatelessWidget {
  final bool showCommentInput;
  final VoidCallback onPressed;

  const NoticiaDetailFloatingButton({
    super.key,
    required this.showCommentInput,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(showCommentInput ? Icons.close : Icons.comment),
      label: Text(showCommentInput ? 'Cerrar' : 'Comentar'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}