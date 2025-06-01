import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';
import 'package:afranco/components/noticia/noticia_card.dart';
import 'package:afranco/components/noticia/noticia_error.dart';
import 'package:afranco/components/noticia/noticia_loading.dart';
import 'package:afranco/components/noticia/noticia_empty_state_enhanced.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/domain/noticia.dart';

class NoticiaListBody extends StatelessWidget {
  final ScrollController scrollController;
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;

  const NoticiaListBody({
    Key? key,
    required this.scrollController,
    required this.onEditPressed,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticiaBloc, NoticiaState>(
      builder: (context, state) {
        if (state.isLoading && state.noticias.isEmpty) {
          return const FullScreenLoading();
        }

        if (state is NoticiaErrorState) {
          return ErrorMessage(
            message: state.error.toString(),
            onRetry: () => context.read<NoticiaBloc>().add(
              CargarNoticiasConPreferenciasEvent(),
            ),
          );
        }

        if (state.noticias.isEmpty) {
          final noticiaBloc = context.read<NoticiaBloc>();
          return NoticiaEmptyStateEnhanced(
            tienesFiltrosActivos: noticiaBloc.tienesFiltrosActivos,
          );
        }

        return ListView.separated(
          controller: scrollController,
          itemCount: state.noticias.length + (state.tieneMas ? 1 : 0),
          separatorBuilder: (_, __) => 
              const SizedBox(height: NoticiaEstilos.espaciadoAlto),
          itemBuilder: (context, index) {
            if (index >= state.noticias.length) {
              return _buildLoadingIndicator(state.isLoading);
            }

            return NoticiaCard(
              noticia: state.noticias[index],
              imageUrl: state.noticias[index].urlImagen,
              onEditPressed: onEditPressed,
              onDelete: onDelete,
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return Visibility(
      visible: isLoading,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
