// components/noticia_edit_modal.dart
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/api/service/noticia_repository.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/api/service/categoria_repository.dart';

class NoticiaEditModal extends StatefulWidget {
  final Noticia noticia;
  final String id;
  final Function()? onNoticiaUpdated;

  final service = NoticiaRepository();

  NoticiaEditModal({
    super.key,
    required this.noticia,
    required this.id,
    this.onNoticiaUpdated
  });

  @override
  State<NoticiaEditModal> createState() => _NoticiaEditModalState();
}

class _NoticiaEditModalState extends State<NoticiaEditModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fuenteController;
  late TextEditingController _imagenController;
  late TextEditingController _urlController;
  final CategoriaRepository _categoriaRepo = CategoriaRepository();
  
  late String _selectedCategoryId;
  List<Categoria> _categorias = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  late String _originalImagen;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia.titulo);
    _descripcionController = TextEditingController(text: widget.noticia.descripcion);
    _fuenteController = TextEditingController(text: widget.noticia.fuente);
    _imagenController = TextEditingController(text: widget.noticia.imagen);
    _urlController = TextEditingController(text: widget.noticia.url);
    _originalImagen = widget.noticia.imagen;
    _selectedCategoryId = widget.noticia.categoryId; // Inicializar con la categoría actual
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
      final imagenUrl = _imagenController.text.isNotEmpty 
          ? _imagenController.text 
          : _originalImagen;

      final noticiaActualizada = Noticia(
        id: widget.noticia.id,
        categoryId: _selectedCategoryId, // Usar la categoría seleccionada
        titulo: _tituloController.text,
        fuente: _fuenteController.text,
        imagen: imagenUrl,
        publicadaEl: widget.noticia.publicadaEl, 
        descripcion: _descripcionController.text,
        url: _urlController.text,
      );

      await widget.service.actualizarNoticia(noticiaActualizada);
      
      if (widget.onNoticiaUpdated != null) {
        widget.onNoticiaUpdated!();
      }

      Navigator.pop(context);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
      );
    } finally {
      if(mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Noticia'),
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
                  hintText: 'Dejar vacío para mantener la actual',
                ),
                keyboardType: TextInputType.url,
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'URL Noticia'),
                keyboardType: TextInputType.url,
              ),
              
              // Dropdown para seleccionar categoría (sin validación)
              
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Seleccionar categoría (opcional)',
                ),
                value: _categorias.any((c) => c.id == _selectedCategoryId) ? _selectedCategoryId : null,

                items: _isLoading
                    ? [const DropdownMenuItem<String>(
                        value: '',
                        child: Text('Cargando categorías...'),
                      )]
                    : _categorias.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryId = newValue ?? '';
                  });
                },

                // Sin validador para que no sea obligatorio
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          style:ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
            foregroundColor: WidgetStatePropertyAll(Theme.of(context).secondaryHeaderColor)
          ),
          child: _isSubmitting 
              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              : const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}