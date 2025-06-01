import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_state.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:afranco/components/comentario/comment_card.dart';

class CommentList extends StatelessWidget {
  final String noticiaId;
  final Function(String, String) onResponderComentario;

  const CommentList({
    super.key,
    required this.noticiaId,
    required this.onResponderComentario,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComentarioBloc, ComentarioState>(
      listener: (context, state) {
        if (state is ComentarioError) {
          SnackBarHelper.showSnackBar(
            context,
            'Error: ${state.errorMessage}',
            statusCode: 500,
          );
        }
      },
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ComentarioLoaded) {
          return _buildList(context, state.comentariosList);
        } else if (state is ComentarioError) {
          return _buildErrorState(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<Comentario> comentarios) {
    if (comentarios.isEmpty) {
      return const Center(
        child: Text(
          'No hay comentarios que coincidan con tu búsqueda',
          textAlign: TextAlign.center,
        ),
      );
    }

    // ✅ SOLUTION: Use Column instead of ListView to avoid unbounded height
    return Column(
      mainAxisSize: MainAxisSize.min, // Important: shrink to content size
      children: [
        for (int index = 0; index < comentarios.length; index++) ...[
          CommentCard(
            comentario: comentarios[index],
            noticiaId: noticiaId,
            onResponder: onResponderComentario,
          ),
          if (index < comentarios.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Add this to prevent infinite height
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar comentarios',
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<ComentarioBloc>()
              ..add(LoadComentarios(noticiaId: noticiaId)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}