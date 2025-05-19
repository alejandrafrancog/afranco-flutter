import 'package:afranco/api/service/reporte_service.dart';
import 'package:afranco/data/base_repository.dart';
import 'package:afranco/domain/reporte.dart';

class ReporteRepository extends BaseRepository {
  final ReporteService _reporteService = ReporteService();

  Future<List<Reporte>> obtenerReportes() async {
    return handleApiCall(() => _reporteService.getReportes());
  }

  Future<int> obtenerNumeroReportes(String noticiaId) async {
    checkForEmpty([MapEntry('noticiaId', noticiaId)]);
    
    return handleApiCall(() async {
      final reportes = await _reporteService.getReportesPorNoticia(noticiaId);
      return reportes.length;
    });
  }

  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    checkForEmpty([
      MapEntry('noticiaId', noticiaId),
      MapEntry('motivo', motivo.toString()),
    ]);

    return handleApiCall(
      () => _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      ),
    );
  }

  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    checkForEmpty([MapEntry('noticiaId', noticiaId)]);
    
    return handleApiCall(
      () => _reporteService.getReportesPorNoticia(noticiaId),
    );
  }

  Future<void> eliminarReporte(String reporteId) async {
    checkForEmpty([MapEntry('reporteId', reporteId)]);
    
    await handleApiCall(
      () => _reporteService.eliminarReporte(reporteId),
    );
  }
}