// components/noticia_edit_modal.dart
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/api/service/noticia_service.dart';

class NoticiaEditModal extends StatefulWidget {
  final Noticia noticia;
  final String id;
  final service = NoticiaService();

  NoticiaEditModal({
    super.key,
    required this.noticia,
    required this.id,

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
        titulo: _tituloController.text,
        fuente: _fuenteController.text,
        imagen: imagenUrl,
        publicadaEl: widget.noticia.publicadaEl, 
        descripcion: _descripcionController.text,
        url: _urlController.text,
      );

      await widget.service.actualizarNoticia(noticiaActualizada);
      
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
          child: _isSubmitting 
              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              : const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}