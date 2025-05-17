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
      title: const Text('Reportar Noticia'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<MotivoReporte>(
            value: _selectedMotivo,
            hint: const Text('Selecciona un motivo'),
            onChanged: (MotivoReporte? value) {
              setState(() => _selectedMotivo = value);
            },
            items:
                MotivoReporte.values.map((MotivoReporte motivo) {
                  return DropdownMenuItem<MotivoReporte>(
                    value: motivo,
                    child: Text(getMotivoDisplayName(motivo)),
                  );
                }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed:
              _isSubmitting || _selectedMotivo == null
                  ? null
                  : () {
                    setState(() => _isSubmitting = true);
                    _submitReporte();
                  },
          child:
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Reportar'),
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
