// components/noticia_modals.dart
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';

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
  final double? sizedBoxHeight = 20.5;
  //final _urlController = TextEditingController();
  bool _isSubmitting = false;
  final CategoriaRepository _categoriaRepo = di<CategoriaRepository>();
  Categoria? _categoriaSeleccionada;
  List<Categoria> _categorias = [];
  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaRepo.getCategorias();
      if (mounted) {
        setState(() {
          _categorias = categorias;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
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
          _imagenController.text.isEmpty
              ? 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}'
              : _imagenController.text;

      final nuevaNoticia = Noticia(
        id: '',
        categoriaId: _categoriaSeleccionada?.id ?? '',
        titulo: _tituloController.text,
        fuente: _fuenteController.text,
        urlImagen: imagenUrl,
        publicadaEl: DateTime.now(),
        descripcion: _descripcionController.text,
        contadorReportes: 0,
        contadorComentarios: 0,
      );

      await widget.service.crearNoticia(nuevaNoticia);

      widget.onNoticiaCreated(nuevaNoticia);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Noticia', style: NoticiaEstilos.tituloModal),
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
                  hintText: 'Dejar vacío para imagen aleatoria',
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Permitir vacío
                  }
                  const urlPattern = r'^(https?:\/\/)[^\s$.?#].[^\s]*$';
                  final result = RegExp(
                    urlPattern,
                    caseSensitive: false,
                  ).hasMatch(value);

                  if (!result) {
                    return 'Ingrese una URL válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: sizedBoxHeight),

              DropdownButtonFormField<Categoria>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items:
                    _categorias.map((categoria) {
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
                  : const Text('Crear Noticia'),
        ),
      ],
    );
  }
}
