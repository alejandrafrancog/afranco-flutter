// components/noticia_modals.dart
import 'package:afranco/api/service/categoria_repository.dart';
import 'package:afranco/domain/category.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/api/service/noticia_repository.dart';

class NoticiaCreationModal extends StatefulWidget {
  final Function(Noticia) onNoticiaCreated;
  final NoticiaRepository service;

  const NoticiaCreationModal({
    super.key,
    required this.onNoticiaCreated,
    required this.service,
  });

  @override
  State<NoticiaCreationModal> createState() => _NoticiaCreationModalState();
}

class _NoticiaCreationModalState extends State<NoticiaCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _fuenteController = TextEditingController();
  final _imagenController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isSubmitting = false;
  final CategoriaRepository _categoriaRepo = CategoriaRepository();
  Categoria? _categoriaSeleccionada;
  bool _isLoading = true;
  List<Categoria> _categorias = [];
  @override
  void initState(){
    super.initState();
    _cargarCategorias();
  }
  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaRepo.getCategorias();
      if (mounted) {
        setState(() {
          _categorias = categorias;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar categorías: $e')),
        );
      }
    }
  }
Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  try {
    final imagenUrl = _imagenController.text.isEmpty
        ? 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}'
        : _imagenController.text;

    final nuevaNoticia = Noticia(
      id: '',
      categoryId: _categoriaSeleccionada?.id ?? '',  // Aquí el valor es vacío si no se selecciona
      titulo: _tituloController.text,
      fuente: _fuenteController.text,
      imagen: imagenUrl,
      publicadaEl: DateTime.now(),
      descripcion: _descripcionController.text,
      url: _urlController.text,
    );

    await widget.service.crearNoticia(nuevaNoticia);

    widget.onNoticiaCreated(nuevaNoticia);
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al crear: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Noticia'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _fuenteController,
                decoration: const InputDecoration(labelText: 'Fuente'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(
                  labelText: 'URL Imagen',
                  hintText: 'Dejar vacío para imagen aleatoria',
                ),
                keyboardType: TextInputType.url,
              ),
              
              DropdownButtonFormField<Categoria>(
                  value: _categoriaSeleccionada,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: _categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                      child: Text(categoria.nombre),
                    );
                  }).toList(),
                  onChanged: (nueva) {
                    setState(() => _categoriaSeleccionada = nueva);
                  },
                  validator: (_) => null,
              ),

              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'URL Noticia'),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting 
              ? null 
              : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting 
              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              : const Text('Crear Noticia'),
        ),
      ],
    );
  }
}