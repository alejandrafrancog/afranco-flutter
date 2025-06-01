import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_state.dart';
import 'package:afranco/components/comentario/comment_list.dart';
import 'package:afranco/components/comentario/comment_input_form.dart';
import 'package:afranco/components/comentario/comment_search_bar.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class NoticiaDetailScreen extends StatefulWidget {
  final Noticia noticia;

  const NoticiaDetailScreen({
    super.key,
    required this.noticia,
  });

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
    
    // Inicializar animaciones
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Cargar comentarios y iniciar animaciones
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

  void _shareNoticia() {
    final String shareText = '''
${widget.noticia.titulo}

${widget.noticia.descripcion}

📱 Compartido desde la app de noticias
''';
    
    Share.share(
      shareText,
      subject: widget.noticia.titulo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar con imagen hero
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareNoticia,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: _toggleImageExpansion,
                child: Hero(
                  tag: 'noticia-image-${widget.noticia.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(127),
                        ],
                      ),
                    ),
                    child: widget.noticia.urlImagen.isNotEmpty
                        ? Image.network(
                            widget.noticia.urlImagen,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),
              ),
            ),
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
                    child: _buildContent(),
                  ),
                );
              },
            ),
          ),

          // Sección de comentarios como Sliver
          SliverToBoxAdapter(
            child: _buildCommentsSection(),
          ),
        ],
      ),
      
      // Botón flotante para comentarios
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _showCommentInput = !_showCommentInput;
          });
        },
        icon: Icon(_showCommentInput ? Icons.close : Icons.comment),
        label: Text(_showCommentInput ? 'Cerrar' : 'Comentar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade600,
          ],
        ),
      ),
      child: const Icon(
        Icons.article,
        size: 80,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador visual
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Información de la noticia
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoría y fecha
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(128),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.noticia.categoriaId ?? 'General',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy').format(widget.noticia.publicadaEl),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Título
                Text(
                  widget.noticia.titulo,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Fuente
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.source,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Fuente: ${widget.noticia.fuente}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Contenido completo (usando descripción)
                Text(
                  widget.noticia.descripcion,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Información adicional
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.noticia.tiempoLecturaFormateado(),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (widget.noticia.contadorComentarios != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.comment,
                              size: 14,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.noticia.contadorComentarios}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Divider con estilo
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.grey.shade300,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      color: Colors.white, // Asegurar fondo blanco
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ✅ Importante: usar mainAxisSize.min
        children: [
          // Header de comentarios
          Row(
            children: [
              const Icon(Icons.comment_outlined, size: 24),
              const SizedBox(width: 8),
              Text(
                'Comentarios',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    _ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() => _ordenAscendente = !_ordenAscendente);
                    context.read<ComentarioBloc>().add(
                      OrdenarComentarios(ascendente: _ordenAscendente),
                    );
                  },
                  tooltip: _ordenAscendente ? 'Más antiguos primero' : 'Más recientes primero',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de búsqueda
          CommentSearchBar(
            busquedaController: _busquedaController,
            onSearch: _handleSearch,
            noticiaId: widget.noticia.id ?? '',
          ),
          
          const SizedBox(height: 16),
          
          // Input de comentario (condicional)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showCommentInput ? null : 0,
            child: _showCommentInput
                ? CommentInputForm(
                    noticiaId: widget.noticia.id ?? '',
                    comentarioController: _comentarioController,
                    respondingToId: _respondingToId,
                    respondingToAutor: _respondingToAutor,
                    onCancelarRespuesta: _cancelarRespuesta,
                  )
                : const SizedBox.shrink(),
          ),
          
          if (_showCommentInput) const SizedBox(height: 16),
          
          // Lista de comentarios - ✅ SECCIÓN CORREGIDA
          BlocBuilder<ComentarioBloc, ComentarioState>(
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
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ Importante
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
                              LoadComentarios(noticiaId: widget.noticia.id ?? ''),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (state is ComentarioLoaded) {
                if (state.comentariosList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ✅ Importante
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
                
                // ✅ SOLUCIÓN: Envolver CommentList en un Container con shrinkWrap
                return Container(
                  // No definir altura para que tome el espacio necesario
                  child: CommentList(
                    noticiaId: widget.noticia.id ?? '',
                    onResponderComentario: (comentarioId, autor) {
                      setState(() {
                        _respondingToId = comentarioId;
                        _respondingToAutor = autor;
                        _showCommentInput = true;
                      });
                    },
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Espaciado final
          const SizedBox(height: 100),
        ],
      ),
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
}