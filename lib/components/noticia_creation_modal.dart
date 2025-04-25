// components/noticia_modals.dart
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    try {
      // Asignar URL de imagen por defecto si está vacío
      final imagenUrl = _imagenController.text.isEmpty
          ? 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}'
          : _imagenController.text;

      final nuevaNoticia = Noticia(
        id: '',
        titulo: _tituloController.text,
        fuente: _fuenteController.text,
        imagen: imagenUrl,  // Usar URL generada o la ingresada
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
      if(mounted) setState(() => _isSubmitting = false);
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