import 'dart:async';
import 'package:flutter/material.dart';
import 'package:afranco/api/service/noticia_service.dart';
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

class NoticiaScreen extends StatefulWidget {
  final NoticiaService service = NoticiaService();

  
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
  bool _ordenarPorFecha = true; // Nuevo estado para controlar el orden

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
      _noticias.addAll(nuevasNoticias);
      _currentPage++;
      _hasMore = nuevasNoticias.isNotEmpty;

      if (nuevasNoticias.isNotEmpty) {
        _ultimaActualizacion = DateTime.now();
      }
    });

  } catch (e) {
    String errorMessage = 'Error desconocido';
    Color errorColor = Colors.grey;

    if (e is ApiException) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
      errorMessage = errorData['message'];
      errorColor = errorData['color'];
    } else {
      errorMessage = 'Error inesperado: $e';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
    );

    setState(() {
      _isLoading = false;
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
void _alternarOrden() {
  setState(() {
    _ordenarPorFecha = !_ordenarPorFecha;
    _noticias.clear(); // Limpiar lista existente inmediatamente
  });
  _loadMoreNoticias(resetear: true); // Forzar recarga desde página 1
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    appBar: AppBar(
      title: const Text(NoticiaConstants.appTitle, 
      style: NoticiaEstilos.tituloAppBar),
      backgroundColor: Colors.lightGreen,
      actions: [
        IconButton(
          icon: Icon(Icons.sort, 
          color: _ordenarPorFecha ? const Color.fromARGB(255, 255, 255, 255) : Colors.green),
          tooltip: NoticiaConstants.tooltipOrden,
          onPressed: _alternarOrden,
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
      backgroundColor: Colors.lightGreen,
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
        return NoticiaCard(
          noticia: _noticias[index],
          imageUrl: _noticias[index].imagen,
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
