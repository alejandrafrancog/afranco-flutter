// category_list_view.dart
import 'package:flutter/material.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/api/service/categoria_service.dart';
import 'package:afranco/components/category_card.dart'; // Agregá esta línea

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoriaScreen> {
  late final CategoryService _categoryService;
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _futureCategories = _categoryService.fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay categorías disponibles.'));
          }

          final categorias = snapshot.data!;
          return ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
            return CategoryCard(
              category: categorias[index],
              onCategoriaEliminada: () {
                setState(() {
                  _futureCategories = _categoryService.fetchAllCategories();
                });
              },
              );
            },
        ); // Este paréntesis estaba faltando

          
        },
      ),
    );
  }
  void _eliminarCategoria(String id) async {
  try {
    await _categoryService.removeCategory(id);
    setState(() {
      _futureCategories = _categoryService.fetchAllCategories(); // refresca la lista
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoría eliminada')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error eliminando categoría: $e')),
    );
  }
}
}
