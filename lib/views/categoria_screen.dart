
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_state.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/components/category_card.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  CategoriaScreenState createState() => CategoriaScreenState();
}

class CategoriaScreenState extends State<CategoriaScreen> {
  @override
void initState() {
  super.initState();
  // Usar addPostFrameCallback para asegurar que el contexto está disponible
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<CategoriaBloc>().add(CategoriaInitEvent());
  });
}

  String generarImagenUrl() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    return 'https://picsum.photos/seed/$seed/600/400';
  }

Future<void> _agregarCategoria() async {
  final nuevaCategoriaData = await _mostrarDialogCategoria(context);
  
  if (nuevaCategoriaData != null) {
    final nuevaCategoria = Categoria(
      id: '', 
      nombre: nuevaCategoriaData['nombre'],
      descripcion: nuevaCategoriaData['descripcion'] ?? 'Descripción categoría',
      imagenUrl: generarImagenUrl(),
    );

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
Future<Map<String, dynamic>?> _mostrarDialogCategoria(
    BuildContext context, {
    Categoria? categoria,
  }) async {
    final TextEditingController nombreController = TextEditingController(
  text: categoria?.nombre ?? '',
);
final TextEditingController descripcionController = TextEditingController(
  text: categoria?.descripcion ?? '',
);

return showDialog<Map<String, dynamic>>(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text(
        categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Categoría',
            ),
          ),
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(
              labelText: 'Descripción de la Categoría',
              labelStyle: TextStyle(color: Colors.grey)
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nombreController.text.isNotEmpty) {
              Navigator.pop(context, {
                'nombre': nombreController.text,
                'descripcion': descripcionController.text,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El nombre no puede estar vacío'),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  },
);
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
                    itemCount: state.categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = state.categorias[index];
                      return CategoryCard(
                        category: categoria,
                        onCategoriaEliminada: () => context
                            .read<CategoriaBloc>()
                            .add(CategoriaInitEvent()),
                      );
                    },
                  );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCategoria,
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }
}