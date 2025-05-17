import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/components/noticia/delete_noticia_modal.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
// Importamos el archivo de la pantalla de comentarios
import 'package:afranco/views/comentario_screen.dart';
// Importamos el bloc de comentarios
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;
  final CategoriaRepository repository = CategoriaRepository();
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;

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
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
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

            // Fecha
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}',
                style: NoticiaEstilos.fuenteNoticia,
              ),
            ),

            // Categoría
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: FutureBuilder<String>(
                future: noticia.obtenerNombreCategoria(
                  repository.getCategorias(),
                  noticia.categoryId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "Cargando...",
                      style: NoticiaEstilos.fuenteNoticia,
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(
                      "Error: ${snapshot.error}",
                      style: NoticiaEstilos.fuenteNoticia,
                    );
                  }
                  return Text(
                    snapshot.data ?? "Sin Categoría",
                    style: NoticiaEstilos.fuenteNoticia,
                  );
                },
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
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        noticia.descripcion,
                        style: NoticiaEstilos.descripcionNoticia,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Imagen
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
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
                        Flexible(
                          child: Text(
                            noticia.fuente,
                            style: NoticiaEstilos.fuenteNoticia,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        const SizedBox(width: 8),
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
                      IconButton(
                        icon: const Icon(Icons.comment, size: 24),
                        tooltip: 'Comentarios',
                        onPressed: () {
                          // Disparamos el evento para cargar los comentarios de esta noticia
                          context.read<ComentarioBloc>().add(
                            LoadComentarios(noticiaId: noticia.id),
                          );

                          // Navegamos a la pantalla de comentarios
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
                      IconButton(
                        icon: const Icon(Icons.share, size: 24),
                        tooltip: 'Compartir',
                        onPressed: () {},
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
                                child: Text('Editar'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Eliminar'),
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
