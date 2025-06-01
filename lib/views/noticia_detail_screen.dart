import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/components/noticia/detail/noticia_detail_app_bar.dart';
import 'package:afranco/components/noticia/detail/noticia_detail_content.dart';
import 'package:afranco/components/noticia/detail/noticia_detail_comments_section.dart';
import 'package:afranco/components/noticia/detail/noticia_detail_floating_button.dart';

class NoticiaDetailScreen extends StatefulWidget {
  final Noticia noticia;

  const NoticiaDetailScreen({super.key, required this.noticia});

  @override
  State<NoticiaDetailScreen> createState() => _NoticiaDetailScreenState();
}

class _NoticiaDetailScreenState extends State<NoticiaDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _heroAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _ordenAscendente = true;
  String? _respondingToId;
  String? _respondingToAutor;
  bool _showCommentInput = false;
  bool _isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComentarioBloc>().add(
        LoadComentarios(noticiaId: widget.noticia.id ?? ''),
      );
      _heroAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _contentAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    _scrollController.dispose();
    _heroAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _cancelarRespuesta() {
    setState(() {
      _respondingToId = null;
      _respondingToAutor = null;
      _comentarioController.clear();
      _showCommentInput = false;
    });
  }

  void _toggleImageExpansion() {
    setState(() {
      _isImageExpanded = !_isImageExpanded;
    });
  }

  void _toggleCommentInput() {
    setState(() {
      _showCommentInput = !_showCommentInput;
    });
  }

  void _handleResponderComentario(String comentarioId, String autor) {
    setState(() {
      _respondingToId = comentarioId;
      _respondingToAutor = autor;
      _showCommentInput = true;
    });
  }

  void _handleOrdenarComentarios() {
    setState(() => _ordenAscendente = !_ordenAscendente);
    context.read<ComentarioBloc>().add(
      OrdenarComentarios(ascendente: _ordenAscendente),
    );
  }

  void _handleSearch() {
    if (_busquedaController.text.isEmpty) {
      context.read<ComentarioBloc>().add(
        LoadComentarios(noticiaId: widget.noticia.id ?? ''),
      );
    } else {
      context.read<ComentarioBloc>().add(
        BuscarComentarios(
          noticiaId: widget.noticia.id ?? '',
          criterioBusqueda: _busquedaController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar con imagen hero
          NoticiaDetailAppBar(
            noticia: widget.noticia,
            onImageTap: _toggleImageExpansion,
            isImageExpanded: _isImageExpanded,
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: NoticiaDetailContent(noticia: widget.noticia),
                  ),
                );
              },
            ),
          ),

          // Sección de comentarios
          SliverToBoxAdapter(
            child: NoticiaDetailCommentsSection(
              noticia: widget.noticia,
              comentarioController: _comentarioController,
              busquedaController: _busquedaController,
              ordenAscendente: _ordenAscendente,
              respondingToId: _respondingToId,
              respondingToAutor: _respondingToAutor,
              showCommentInput: _showCommentInput,
              onCancelarRespuesta: _cancelarRespuesta,
              onResponderComentario: _handleResponderComentario,
              onOrdenarComentarios: _handleOrdenarComentarios,
              onSearch: _handleSearch,
            ),
          ),
        ],
      ),

      // Botón flotante para comentarios
      floatingActionButton: NoticiaDetailFloatingButton(
        showCommentInput: _showCommentInput,
        onPressed: _toggleCommentInput,
      ),
    );
  }
}