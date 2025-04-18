import 'package:flutter/material.dart';
import '../api/service/noticia_service.dart';
import '../domain/noticia.dart';
import '../noticias_estilos.dart';
import '../components/noticia_error.dart';
import '../components/noticia_card.dart';
import '../components/noticia_loading.dart';
import '../components/noticia_empty_state.dart';
class NoticiaScreen extends StatefulWidget {
  final NoticiaService service = NoticiaService();
  
   NoticiaScreen({super.key});

  @override
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final List<Noticia> _noticias = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _errorMessage;

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

  Future<void> _loadMoreNoticias() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final nuevasNoticias = await widget.service.obtenerNoticiasPaginadas(
        numeroPagina: _currentPage,
      );
      
      setState(() {
        _noticias.addAll(nuevasNoticias);
        _currentPage++;
        _hasMore = nuevasNoticias.isNotEmpty;
      });
      
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Últimas Noticias', style: NoticiaEstilos.tituloAppBar),
        backgroundColor: Colors.lightGreen,
      ),
      body: _buildBodyContent(),
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
          imageUrl: 'https://picsum.photos/400/200?random=$index',
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
