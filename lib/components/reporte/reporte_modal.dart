import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/reporte.dart';
import 'package:afranco/helpers/motivo_helper.dart';

class ReporteModal extends StatefulWidget {
  final String noticiaId;
  final Function(MotivoReporte) onSubmit;

  const ReporteModal({
    super.key,
    required this.noticiaId,
    required this.onSubmit,
  });

  @override
  State<ReporteModal> createState() => _ReporteModalState();
}

class _ReporteModalState extends State<ReporteModal> {
  MotivoReporte? _selectedMotivo;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reportar noticia', style: NoticiaEstilos.tituloModal),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              errorText:
                  _selectedMotivo == null && _isSubmitting
                      ? 'Selecciona un motivo'
                      : null,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<MotivoReporte>(
                isExpanded: true,
                value: _selectedMotivo,
                hint: const Text(
                  'Selecciona un motivo',
                  style: TextStyle(color: Colors.grey),
                ),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 28,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                elevation: 4,
                onChanged: (MotivoReporte? value) {
                  setState(() => _selectedMotivo = value);
                },
                items:
                    MotivoReporte.values.map((MotivoReporte motivo) {
                      return DropdownMenuItem<MotivoReporte>(
                        value: motivo,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            getMotivoDisplayName(motivo),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              _isSubmitting || _selectedMotivo == null
                  ? null
                  : () {
                    setState(() => _isSubmitting = true);
                    _submitReporte();
                  },
          child:
              _isSubmitting
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    'Reportar',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
        ),
      ],
    );
  }

  // Y en el método de envío:
  void _submitReporte() {
    if (_selectedMotivo != null) {
      widget.onSubmit(_selectedMotivo!); // Envía solo el enum
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte enviado exitosamente'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
