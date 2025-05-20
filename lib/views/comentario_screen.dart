import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';

// Importaciones de componentes
import 'package:afranco/components/comentario/comment_app_bar.dart';
import 'package:afranco/components/comentario/comment_search_bar.dart';
import 'package:afranco/components/comentario/comment_list.dart';
import 'package:afranco/components/comentario/comment_input_form.dart';

class ComentarioScreen extends StatelessWidget {
  final String noticiaId;

  const ComentarioScreen({super.key, required this.noticiaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ComentarioBloc>()
        ..add(LoadComentarios(noticiaId: noticiaId)),
      child: _ComentarioScreenContent(noticiaId: noticiaId),
    );
  }
}

class _ComentarioScreenContent extends StatefulWidget {
  final String noticiaId;

  const _ComentarioScreenContent({required this.noticiaId});

  @override
  State<_ComentarioScreenContent> createState() =>
      _ComentariosScreenContentState();
}

class _ComentariosScreenContentState extends State<_ComentarioScreenContent> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  bool _ordenAscendente = true;
  String? _respondingToId;
  String? _respondingToAutor;

  void _cancelarRespuesta() {
    setState(() {
      _respondingToId = null;
      _respondingToAutor = null;
      _comentarioController.clear();
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommentAppBar(
        ordenAscendente: _ordenAscendente,
        onOrdenChanged: (ascendente) {
          setState(() => _ordenAscendente = ascendente);
          context.read<ComentarioBloc>().add(OrdenarComentarios(ascendente: ascendente));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CommentSearchBar(
              busquedaController: _busquedaController,
              onSearch: () => _handleSearch(),
              noticiaId: widget.noticiaId,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CommentList(
                noticiaId: widget.noticiaId,
                onResponderComentario: (comentarioId, autor) {
                  setState(() {
                    _respondingToId = comentarioId;
                    _respondingToAutor = autor;
                  });
                },
              ),
            ),
            CommentInputForm(
              noticiaId: widget.noticiaId,
              comentarioController: _comentarioController,
              respondingToId: _respondingToId,
              respondingToAutor: _respondingToAutor,
              onCancelarRespuesta: _cancelarRespuesta,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    if (_busquedaController.text.isEmpty) {
      context.read<ComentarioBloc>().add(LoadComentarios(noticiaId: widget.noticiaId));
    } else {
      context.read<ComentarioBloc>().add(
        BuscarComentarios(
          noticiaId: widget.noticiaId,
          criterioBusqueda: _busquedaController.text,
        ),
      );
    }
  }
}