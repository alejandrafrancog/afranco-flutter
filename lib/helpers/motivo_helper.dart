import 'package:afranco/domain/reporte.dart';

String getMotivoDisplayName(MotivoReporte motivo) {
  switch (motivo) {
    case MotivoReporte.noticiaInapropiada:
      return 'Contenido inapropiado';
    case MotivoReporte.informacionFalsa:
      return 'Información falsa';
    case MotivoReporte.otro:
      return 'Otro motivo';
  }
}