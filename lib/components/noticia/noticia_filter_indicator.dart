import 'package:flutter/material.dart';

class NoticiaFilterIndicator extends StatelessWidget {
  final int cantidadNoticias;

  const NoticiaFilterIndicator({
    super.key,
    required this.cantidadNoticias,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.amber.shade100,
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: Colors.amber.shade700,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Filtros activos - $cantidadNoticias noticias',
            style: TextStyle(
              fontSize: 14,
              color: Colors.amber.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
