import 'package:afranco/bloc/reporte_bloc/reporte_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_event.dart';
import 'package:afranco/components/reporte/reporte_modal.dart';
import 'package:afranco/components/noticia/delete_noticia_modal.dart';
import 'package:afranco/core/comentario_cache_service.dart';
import 'package:afranco/core/reporte_cache_service.dart';
import 'package:afranco/data/reporte_repository.dart';
import 'package:afranco/helpers/category_helper.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
// Importamos el archivo de la pantalla de comentarios
import 'package:afranco/views/comentario_screen.dart';
// Importamos el bloc de comentarios
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;
  final reporteRepository = di<ReporteRepository>();

  NoticiaCard({
    super.key,
    required this.noticia,
    required this.imageUrl,
    required this.onEditPressed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: NoticiaEstilos.margenCard,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                noticia.titulo,
                style: NoticiaEstilos.tituloNoticia,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),

            // Categoría
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF6F9),
                  border: Border.all(color: const Color(0xFFEDF6F9), width: 2),
                  borderRadius: BorderRadius.circular(82),
                ),
                child: FutureBuilder<String>(
                  future: CategoryHelper.getCategoryName(noticia.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        snapshot.data ?? 'Sin categoría',
                        style: NoticiaEstilos.fuenteNoticia,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Fecha
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}',
                style: NoticiaEstilos.fuenteNoticia,
              ),
            ),

            // Contenido: Imagen + Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        noticia.descripcion,
                        style: NoticiaEstilos.descripcionNoticia,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Imagen
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),

                          fit: BoxFit.cover,
                          matchTextDirection: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer con fuente, tiempo de lectura y acciones
            Padding(
              padding: const EdgeInsets.only(
                left: 22,
                right: 5,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.source,
                          size: 16,
                          color: Colors.grey,
                          weight: 100,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            noticia.fuente,
                            style: NoticiaEstilos.fuenteNoticia,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                          weight: 100,
                        ),
                        const SizedBox(width: 3),

                        Text(
                          "${noticia.tiempoLectura} min",
                          style: NoticiaEstilos.fuenteNoticia,
                        ),
                      ],
                    ),
                  ),

                  // Iconos
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // En la sección de iconos de NoticiaCard
                      IconButton(
                        icon: Row(
                          children: [
                            FutureBuilder<int>(
                              future: di<ComentarioCacheService>()
                                  .getNumeroComentarios(noticia.id),
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
                            LoadComentarios(noticiaId: noticia.id),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ComentarioScreen(noticiaId: noticia.id),
                            ),
                          );
                        },
                      ),

                      // CONTADOR DE REPORTES CON STREAM BUILDER
                      IconButton(
                        icon: Row(
                          children: [
                            StreamBuilder<int>(
                              stream: di<ReporteCacheService>()
                                  .getReportesCountStream(noticia.id),
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
                            const Icon(
                              Icons.warning_amber,
                              size: 24,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        tooltip: 'Reportes de esta noticia',
                        onPressed:
                            () => showDialog(
                              context: context,
                              builder:
                                  (context) => ReporteModal(
                                    noticiaId: noticia.id,
                                    onSubmit: (motivo) {
                                      final bloc = context.read<ReporteBloc>();
                                      bloc.add(
                                        ReporteCreateEvent(
                                          noticiaId: noticia.id,
                                          motivo: motivo,
                                        ),
                                      );
                                      // Ya no necesitamos el refresh manual
                                      // El stream se actualizará automáticamente
                                    },
                                  ),
                            ),
                      ),

                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEditPressed(noticia);
                              break;
                            case 'delete':
                              showDialog(
                                context: context,
                                builder:
                                    (c) => NoticiaDeleteModal(
                                      noticia: noticia,
                                      id: noticia.id,
                                    ),
                              ).then((resultado) {
                                if (resultado == true) {
                                  onDelete();
                                }
                              });
                              break;
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 15),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 15),
                                    Text('Eliminar'),
                                  ],
                                ),
                              ),
                            ],
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Más acciones',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}