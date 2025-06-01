import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_state.dart';
import 'package:afranco/components/comentario/comment_list_detail.dart';
import 'package:afranco/components/comentario/comment_input_form.dart';
import 'package:afranco/components/comentario/comment_search_bar.dart';

class NoticiaDetailCommentsSection extends StatelessWidget {
  final Noticia noticia;
  final TextEditingController comentarioController;
  final TextEditingController busquedaController;
  final bool ordenAscendente;
  final String? respondingToId;
  final String? respondingToAutor;
  final bool showCommentInput;
  final VoidCallback onCancelarRespuesta;
  final Function(String, String) onResponderComentario;
  final VoidCallback onOrdenarComentarios;
  final VoidCallback onSearch;

  const NoticiaDetailCommentsSection({
    super.key,
    required this.noticia,
    required this.comentarioController,
    required this.busquedaController,
    required this.ordenAscendente,
    required this.respondingToId,
    required this.respondingToAutor,
    required this.showCommentInput,
    required this.onCancelarRespuesta,
    required this.onResponderComentario,
    required this.onOrdenarComentarios,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header de comentarios
          _buildCommentsHeader(context),
          const SizedBox(height: 16),

          // Barra de búsqueda
          CommentSearchBar(
            busquedaController: busquedaController,
            onSearch: onSearch,
            noticiaId: noticia.id ?? '',
          ),
          const SizedBox(height: 16),

          // Input de comentario (condicional)
          _buildCommentInputSection(),
          if (showCommentInput) const SizedBox(height: 16),

          // Lista de comentarios
          _buildCommentsList(context),

          // Espaciado final
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.comment_outlined, size: 24),
        const SizedBox(width: 8),
        Text(
          'Comentarios',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Botón de ordenar
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
              ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
            ),
            onPressed: onOrdenarComentarios,
            tooltip: ordenAscendente
                ? 'Más antiguos primero'
                : 'Más recientes primero',
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInputSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: showCommentInput ? null : 0,
      child: showCommentInput
          ? CommentInputForm(
              noticiaId: noticia.id ?? '',
              comentarioController: comentarioController,
              respondingToId: respondingToId,
              respondingToAutor: respondingToAutor,
              onCancelarRespuesta: onCancelarRespuesta,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCommentsList(BuildContext context) {
    return BlocBuilder<ComentarioBloc, ComentarioState>(
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ComentarioError) {
          return _buildErrorState(context);
        }

        if (state is ComentarioLoaded) {
          if (state.comentariosList.isEmpty) {
            return _buildEmptyState();
          }

          return Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: CommentList(
              noticiaId: noticia.id ?? '',
              onResponderComentario: onResponderComentario,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'Error al cargar comentarios',
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<ComentarioBloc>().add(
                      LoadComentarios(
                        noticiaId: noticia.id ?? '',
                      ),
                    );
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              '¡Sé el primero en comentar!',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}