import 'package:afranco/components/categoria/agregar_categoria_modal.dart';
import 'package:afranco/components/connectivity/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_state.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/components/categoria/category_card.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  CategoriaScreenState createState() => CategoriaScreenState();
}

class CategoriaScreenState extends State<CategoriaScreen> {
  late ScrollController _scrollController;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Usar addPostFrameCallback para asegurar que el contexto está disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriaBloc>().add(CategoriaInitEvent());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        setState(() {
          _isScrollingDown = false;
        });
      }
    }
  }

  String generarImagenUrl() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    return 'https://picsum.photos/seed/$seed/600/400';
  }

  Future<void> _agregarCategoria() async {
    final nuevaCategoriaData = await mostrarDialogCategoria(context);

    if (nuevaCategoriaData != null) {
      final nuevaCategoria = Categoria(
        id: '',
        nombre: nuevaCategoriaData['nombre'],
        descripcion:
            nuevaCategoriaData['descripcion'] ?? 'Descripción categoría',
        imagenUrl: generarImagenUrl(),
      );
      if (!mounted) {
        return;
      }
      // Envía el evento correctamente tipado
      context.read<CategoriaBloc>().add(CreateCategoriaEvent(nuevaCategoria));
      _showSuccessSnackbar(context);
    }
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Categoría agregada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorías'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Recargar categorías',
              onPressed: () {
                context.read<CategoriaBloc>().add(CategoriaInitEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recargando categorías...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CategoriaBloc, CategoriaState>(
          listener: (context, state) {
            if (state is CategoriaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CategoriaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriaError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is CategoriaLoaded) {
              return state.categorias.isEmpty
                  ? const Center(
                    child: Text(
                      'No hay categorías disponibles.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  : ListView.builder(
                    controller: _scrollController,
                    itemCount: state.categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = state.categorias[index];
                      return CategoryCard(category: categoria);
                    },
                  );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: _isScrollingDown ? const Offset(0, 2) : const Offset(0, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isScrollingDown ? 0.0 : 1.0,
            child: FloatingActionButton(
              onPressed: _agregarCategoria,
              tooltip: 'Agregar Categoría',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
