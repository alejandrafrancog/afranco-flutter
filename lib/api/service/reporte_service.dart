import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/reporte.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';

class ReporteService extends BaseService {
  ReporteService() : super();

  /// Obtiene todos los reportes
  Future<List<Reporte>> getReportes() async {
    final data = await get(
      ApiConstantes.reportesEndpoint,
      errorMessage: ReporteConstantes.errorObtenerReportes,
    );

    debugPrint('📊 Procesando ${data.length} reportes');

    return data.map((json) {
      try {
        return json is Map<String, dynamic>
            ? ReporteMapper.fromMap(json)
            : ReporteMapper.fromJson(json.toString());
      } catch (e) {
        debugPrint('❌ Error al deserializar reporte: $e');
        throw ApiException(
          message: ReporteConstantes.errorFormatoInvalido,
          statusCode: 500,
        );
      }
    }).toList();
  }

  /// Crea un nuevo reporte
  Future<Reporte> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    final fecha = DateTime.now().toIso8601String();
    final data = await post(
      ApiConstantes.reportesEndpoint,
      data: {
        'noticiaId': noticiaId,
        'fecha': fecha,
        'motivo': motivo.toValue(),
      },
      errorMessage: ReporteConstantes.errorCrearReporte,
      requireAuthToken: true,
    );

    debugPrint('✅ Reporte creado correctamente');
    return ReporteMapper.fromMap(data);
  }

  /// Obtiene reportes por ID de noticia
  Future<List<Reporte>> getReportesPorNoticia(String noticiaId) async {
    final data = await get<List<dynamic>>(
      ApiConstantes.reportesEndpoint,
      queryParameters: {'noticiaId': noticiaId},
      errorMessage: ReporteConstantes.errorObtenerPorNoticia,
    );

    return data.map((json) => ReporteMapper.fromMap(json)).toList();
  }

  /// Elimina un reporte
  Future<void> eliminarReporte(String reporteId) async {
    await delete(
      '${ApiConstantes.reportesEndpoint}/$reporteId',
      errorMessage: ReporteConstantes.errorEliminarReporte,
      requireAuthToken: true,
    );
    debugPrint('✅ Reporte eliminado correctamente');
  }

  /// Actualiza un reporte existente
  Future<Reporte> actualizarReporte(
    String reporteId,
    Map<String, dynamic> datosActualizados,
  ) async {
    final data = await put(
      '${ApiConstantes.reportesEndpoint}/$reporteId',
      data: datosActualizados,
      errorMessage: ReporteConstantes.errorActualizarReporte,
      requireAuthToken: true,
    );

    debugPrint('✅ Reporte actualizado correctamente');
    return ReporteMapper.fromMap(data);
  }
}
