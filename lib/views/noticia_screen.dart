import 'dart:async';
import 'package:afranco/views/categoria_screen.dart';
import 'package:flutter/material.dart';
import 'package:afranco/api/service/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/components/noticia_error.dart';
import 'package:afranco/components/noticia_card.dart';
import 'package:afranco/components/noticia_loading.dart';
import 'package:afranco/components/noticia_empty_state.dart';
import 'package:afranco/constants.dart';
import 'package:afranco/components/noticia_creation_modal.dart';
import 'package:intl/intl.dart';
import 'package:afranco/helpers/error_helper.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/components/noticia_edit_modal.dart';

class NoticiaScreen extends StatefulWidget {
  final NoticiaRepository service = NoticiaRepository();

  
   NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final List<Noticia> _noticias = [];
  final ScrollController _scrollController = ScrollController();
  DateTime? _ultimaActualizacion; // Nueva variable de estado

  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _errorMessage;
  final bool _ordenarPorFecha = true; // Nuevo estado para controlar el orden

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreNoticias();
  }
  
  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreNoticias();
    }
  }
void _abrirModalEdicion(Noticia noticia) {
  showDialog(
    context: context,
    builder: (context) => NoticiaEditModal(
      noticia: noticia,
      id: noticia.id,
      onNoticiaUpdated: () {
        // Ejecutar en el próximo frame para asegurar que el modal se cerró
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadMoreNoticias(resetear: true);
        });
      },
    ),
  );
}

Future<void> _loadMoreNoticias({bool resetear = false}) async {
  if (_isLoading || (!_hasMore && !resetear)) return;

  setState(() {
    _isLoading = true;
    _errorMessage = null;
    if (resetear) {
      _currentPage = 1;
      _noticias.clear();
      _hasMore = true;
      _ultimaActualizacion = null;
    }
  });

  try {
    final nuevasNoticias = await widget.service.obtenerNoticiasPaginadas(
      numeroPagina: _currentPage,
      ordenarPorFecha: _ordenarPorFecha,
    ).timeout(const Duration(seconds: 15));

    if (!mounted) return;

    setState(() {
      if (resetear) {
        _noticias
          ..clear()
          ..addAll(nuevasNoticias);
        _currentPage = 2;
      } else {
        _noticias.addAll(nuevasNoticias);
        _currentPage++;
      }
      
      _hasMore = nuevasNoticias.length >= NoticiaConstants.pageSize;
      _ultimaActualizacion = DateTime.now();
    });

  } catch (e) {
    // Definir valores predeterminados
    String errorMessage = 'Error desconocido';
    Color errorColor = Colors.grey;

    // Determinar el mensaje y color según el tipo de error
    if (e is ApiException) {
      // Obtener mensaje y color del ErrorHelper
      final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
      errorMessage = errorData['message'] as String;
      errorColor = errorData['color'] as Color;
    } 
    else if (e is TimeoutException) {
      errorMessage = 'Tiempo de espera agotado';
      errorColor = Colors.orange;
    }
    else {
      errorMessage = 'Error inesperado: ${e.toString()}';
      // Mantener el color predeterminado (gris)
    }

    // Mostrar SnackBar solo si el widget sigue montado
    if (mounted) {
      // Este es el SnackBar que mostrará los colores correctos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: errorColor, // Usar el color determinado arriba
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () => _loadMoreNoticias(resetear: true),
          ),
        ),
      );
    }

    // Actualizar el estado para mostrar mensaje en la UI
    setState(() {
      _errorMessage = errorMessage;
    });
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  void _mostrarModalCreacion() {
    showDialog(
      context: context,
      builder: (context) => NoticiaCreationModal(
        service: widget.service,
        onNoticiaCreated: (nuevaNoticia) => _loadMoreNoticias(resetear: true),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    appBar: AppBar(
      title: const Text(NoticiaConstants.appTitle, 
      style: NoticiaEstilos.tituloAppBar),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          icon: Icon(Icons.category),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CategoriaScreen()),
            );
          },
        ),
      
      ],
  ),
    body: Column(
      children: [
        // Sección de última actualización
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.grey[300],
          child: _ultimaActualizacion != null
              ? Text(
                  'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(_ultimaActualizacion!)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // Lista de noticias
        Expanded(
          child: _buildBodyContent(),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _mostrarModalCreacion,
      child: const Icon(Icons.add),
    ),
  );
}
  Widget _buildBodyContent() {
    if (_errorMessage != null) {
      return ErrorMessage(
        message: _errorMessage!,
        onRetry: _loadMoreNoticias,
      );
    }
    
    if (_noticias.isEmpty && _isLoading) {
      return const FullScreenLoading();
    }
    
    if (_noticias.isEmpty) {
      return const EmptyState();
    }
    
    return ListView.separated(
      controller: _scrollController,
      itemCount: _noticias.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: NoticiaEstilos.espaciadoAlto),
     itemBuilder: (context, index) {
  if (index >= _noticias.length) {
    return _buildLoadingIndicator();
  }
  
  // Añadir protección contra índices inválidos
  if (index < 0 || index >= _noticias.length) {
    return const SizedBox.shrink();
  }

  return NoticiaCard(
  noticia: _noticias[index],
  imageUrl: _noticias[index].imagen,
  onEditPressed: _abrirModalEdicion,
  onDelete: () => _loadMoreNoticias(resetear: true),  // <- aquí
);
},
    );
  }

  Widget _buildLoadingIndicator() {
    return Visibility(
      visible: _isLoading,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
