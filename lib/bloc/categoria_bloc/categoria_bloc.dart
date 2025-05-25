import 'package:bloc/bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_state.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/core/category_cache_service.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();
  final CategoryCacheService _cacheService = CategoryCacheService();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CreateCategoriaEvent>(_onCreateCategoria);
    on<UpdateCategoriaEvent>(_onUpdateCategoria);
    on<DeleteCategoriaEvent>(_onDeleteCategoria);
  }

  Future<void> _onInit(CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      // Intentar obtener desde cache primero
      final categorias = await _cacheService.getCategories();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onCreateCategoria(
    CreateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      // Crear la categoría
      await categoriaRepository.crearCategoria(event.categoria);
      
      // Invalidar cache para forzar actualización
      _cacheService.invalidateCache();
      
      // Obtener categorías actualizadas
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      
      // Actualizar cache con los nuevos datos
      _cacheService.updateCache(categoriasActualizadas);
      
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al crear categoría: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCategoria(
    UpdateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      emit(CategoriaLoading());
      
      // Actualizar la categoría
      await categoriaRepository.editarCategoria(
        event.categoria.id ?? '',
        event.categoria,
      );
      
      // Invalidar cache para forzar actualización
      _cacheService.invalidateCache();
      
      // Obtener categorías actualizadas
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      
      // Actualizar cache con los nuevos datos
      _cacheService.updateCache(categoriasActualizadas);
      
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al actualizar: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      emit(CategoriaLoading());
      
      // Eliminar la categoría
      await categoriaRepository.eliminarCategoria(event.categoriaId);
      
      // Invalidar cache para forzar actualización
      _cacheService.invalidateCache();
      
      // Obtener categorías actualizadas
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      
      // Actualizar cache con los nuevos datos
      _cacheService.updateCache(categoriasActualizadas);
      
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al eliminar: ${e.toString()}'));
    }
  }
}