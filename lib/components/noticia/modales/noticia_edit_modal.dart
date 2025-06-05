import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaEditModal extends StatefulWidget {
  final Noticia noticia;
  final String id;
  final Function()? onNoticiaUpdated;
  final service = di<NoticiaRepository>();

  NoticiaEditModal({
    super.key,
    required this.noticia,
    required this.id,
    this.onNoticiaUpdated,
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
  final CategoriaRepository _categoriaRepo = CategoriaRepository();
  final double? sizedBoxHeight = 20.5;

  late String _selectedCategoryId;
  List<Categoria> _categorias = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  late String _originalImagen;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia.titulo);
    _descripcionController = TextEditingController(
      text: widget.noticia.descripcion,
    );
    _fuenteController = TextEditingController(text: widget.noticia.fuente);
    _imagenController = TextEditingController(text: widget.noticia.urlImagen);
    //_urlController = TextEditingController(text: widget.noticia.url);
    _originalImagen = widget.noticia.urlImagen;
    _selectedCategoryId =
        widget.noticia.categoriaId ?? ''; // Inicializar con la categoría actual
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
      final imagenUrl =
          _imagenController.text.isNotEmpty
              ? _imagenController.text
              : _originalImagen;

      final noticiaActualizada = Noticia(
        id: widget.noticia.id,
        categoriaId: _selectedCategoryId, // Usar la categoría seleccionada
        titulo: _tituloController.text,
        fuente: _fuenteController.text,
        urlImagen: imagenUrl,
        publicadaEl: widget.noticia.publicadaEl,
        descripcion: _descripcionController.text,
        contadorComentarios: widget.noticia.contadorComentarios,
        contadorReportes: widget.noticia.contadorReportes,
      );

      await widget.service.actualizarNoticia(noticiaActualizada);

      widget.onNoticiaUpdated!();
      
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Noticia', style: NoticiaEstilos.tituloModal),
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
              SizedBox(height: sizedBoxHeight),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: sizedBoxHeight),
              TextFormField(
                controller: _fuenteController,
                decoration: const InputDecoration(labelText: 'Fuente'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: sizedBoxHeight),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(
                  labelText: 'URL Imagen',
                  hintText: 'Dejar vacío para mantener la actual',
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: sizedBoxHeight),

              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Seleccionar categoría (opcional)',
                ),
                value:
                    _categorias.any((c) => c.id == _selectedCategoryId)
                        ? _selectedCategoryId
                        : null,

                items:
                    _isLoading
                        ? [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('Cargando categorías...'),
                          ),
                        ]
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

              ),

              const SizedBox(height: 6),
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
          style: NoticiaEstilos.estiloBotonPrimario(context),
          child:
              _isSubmitting
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}
