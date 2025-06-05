import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_it/watch_it.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_event.dart';
import 'package:afranco/core/comentario_cache_service.dart';
import 'package:afranco/core/reporte_cache_service.dart';
import 'package:afranco/views/comentario_screen.dart';
import 'package:afranco/components/reporte/reporte_modal.dart';
import 'package:afranco/components/noticia/modales/delete_noticia_modal.dart';

class NoticiaCardActions extends StatelessWidget {
  final Noticia noticia;
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;
  final VoidCallback onNavigateToDetail;

  static const int maxReportesPorNoticia = 3;

  const NoticiaCardActions({
    super.key,
    required this.noticia,
    required this.onEditPressed,
    required this.onDelete,
    required this.onNavigateToDetail,
  });

  bool _puedeReportar(int cantidadReportes) {
    return cantidadReportes < maxReportesPorNoticia;
  }

  void _mostrarDialogoLimiteAlcanzado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.orange),
              SizedBox(width: 8),
              Text('Límite alcanzado'),
            ],
          ),
          content: const Text(
            'Esta noticia ya ha alcanzado el límite máximo de $maxReportesPorNoticia reportes.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón de comentarios
        GestureDetector(
          onTap: () {}, 
          child: IconButton(
            icon: Row(
              children: [
                StreamBuilder<int>(
                  stream: di<ComentarioCacheService>()
                      .getNumeroComentariosStream(
                        noticia.id ?? '',
                      ),
                  initialData: 0,
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return Text(
                      '$count',
                      style: NoticiaEstilos.fuenteNoticia,
                    );
                  },
                ),
                const SizedBox(width: 4),
                const Icon(Icons.comment, size: 24),
              ],
            ),
            tooltip: 'Comentarios',
            onPressed: () {
              context.read<ComentarioBloc>().add(
                LoadComentarios(noticiaId: noticia.id ?? ''),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComentarioScreen(
                    noticiaId: noticia.id ?? '',
                  ),
                ),
              );
            },
          ),
        ),

        // Botón de reportes
        GestureDetector(
          onTap: () {}, // Evita propagación
          child: StreamBuilder<int>(
            stream: di<ReporteCacheService>()
                .getReportesCountStream(noticia.id ?? ''),
            initialData: 0,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              final puedeReportar = _puedeReportar(count);

              return IconButton(
                icon: Row(
                  children: [
                    Text(
                      '$count',
                      style: NoticiaEstilos.fuenteNoticia.copyWith(
                        color:Colors.grey,
                        fontWeight:
                            !puedeReportar ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.warning_amber,
                      size: 24,
                      color: puedeReportar ? Colors.red : Colors.grey,
                    ),
                  ],
                ),
                tooltip: puedeReportar
                    ? 'Reportar esta noticia'
                    : 'Límite de reportes alcanzado ($maxReportesPorNoticia/$maxReportesPorNoticia)',
                onPressed: () {
                  if (!puedeReportar) {
                    _mostrarDialogoLimiteAlcanzado(context);
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) => ReporteModal(
                      noticiaId: noticia.id ?? '',
                      onSubmit: (motivo) {
                        final bloc = context.read<ReporteBloc>();
                        bloc.add(
                          ReporteCreateEvent(
                            noticiaId: noticia.id ?? '',
                            motivo: motivo,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Menú de opciones
        GestureDetector(
          onTap: () {}, // Evita propagación
          child: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEditPressed(noticia);
                  break;
                case 'delete':
                  showDialog(
                    context: context,
                    builder: (c) => NoticiaDeleteModal(
                      noticia: noticia,
                      id: noticia.id ?? '',
                    ),
                  ).then((resultado) {
                    if (resultado == true) {
                      onDelete();
                    }
                  });
                  break;
                case 'view_detail':
                  onNavigateToDetail();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'view_detail',
                child: Row(
                  children: [
                    Icon(Icons.article, size: 15),
                    SizedBox(width: 8),
                    Text('Ver detalle'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 15),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 15),
                    SizedBox(width: 8),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
            tooltip: 'Más acciones',
          ),
        ),
      ],
    );
  }
}
