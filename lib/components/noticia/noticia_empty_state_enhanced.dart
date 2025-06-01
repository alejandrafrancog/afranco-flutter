import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';

class NoticiaEmptyStateEnhanced extends StatelessWidget {
  final bool tienesFiltrosActivos;

  const NoticiaEmptyStateEnhanced({
    super.key,
    required this.tienesFiltrosActivos,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            tienesFiltrosActivos
                ? Icons.filter_list_off
                : Icons.article_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(
              left: 79,
              right: 35,
              top: 15,
              bottom: 29,
            ),
            child: Text(
              tienesFiltrosActivos
                  ? 'No hay noticias que coincidan con los filtros seleccionados.'
                  : 'No hay noticias disponibles en este momento.',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
          if (tienesFiltrosActivos) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                context.read<NoticiaBloc>().add(
                  FilterNoticiasByPreferencias([]),
                );
              },
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar filtros'),
            ),
          ],
        ],
      ),
    );
  }
}
