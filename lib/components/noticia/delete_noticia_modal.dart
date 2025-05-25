import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaDeleteModal extends StatefulWidget {
  final Noticia noticia;
  final String id;
  final service = di<NoticiaRepository>();

  NoticiaDeleteModal({
    super.key,
    required this.noticia,
    required this.id,
  });

  @override
  State<NoticiaDeleteModal> createState() => _NoticiaDeleteModalState();
}

class _NoticiaDeleteModalState extends State<NoticiaDeleteModal> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    setState(() => _isDeleting = true);
    try {
      await widget.service.eliminarNoticia(widget.id);
      if (mounted) {
        Navigator.pop(context, true); // Envía true como resultado de éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error eliminando noticia: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // Cierra el modal en caso de error
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirmar eliminación',
            style: NoticiaEstilos.tituloModal
          ),
          const SizedBox(height: 15),
          Text(
            '¿Estás seguro de eliminar la noticia "${widget.noticia.titulo}"?',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isDeleting ? null : () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isDeleting ? null : _confirmDelete,
                style:NoticiaEstilos.estiloBotonPrimario(context),
                child: _isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Eliminar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}