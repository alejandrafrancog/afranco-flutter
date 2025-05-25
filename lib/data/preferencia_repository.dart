import 'package:afranco/data/base_repository.dart';
import 'package:afranco/api/service/preferencia_service.dart';
import 'package:afranco/core/secure_storage_service.dart';
import 'package:afranco/domain/preferencia.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaRepository extends BaseRepository {
  final PreferenciaService _preferenciaService = di<PreferenciaService>();
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  Preferencia? _cachedPreferencias;

  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return handleApiCall(() async {
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();
      return _cachedPreferencias!.categoriasSeleccionadas;
    });
  }

  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return handleApiCall(() async {
      final email = await _secureStorage.getUserEmail() ?? '';
      debugPrint('💾 Guardando categorías para usuario: $email');
      
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds,
      );
      
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
    });
  }

  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    checkForEmpty([MapEntry('categoriaId', categoriaId)]);

    await handleApiCall(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        await guardarCategoriasSeleccionadas([...categorias, categoriaId]);
      }
    });
  }

  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    checkForEmpty([MapEntry('categoriaId', categoriaId)]);

    await handleApiCall(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      await guardarCategoriasSeleccionadas(
        categorias.where((id) => id != categoriaId).toList(),
      );
    });
  }

  Future<void> limpiarFiltrosCategorias() async {
    await handleApiCall(() async {
      final email = await _secureStorage.getUserEmail() ?? '';
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: const [],
      );
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
    });
  }

  void invalidarCache() {
    _cachedPreferencias = null;
  }
}
