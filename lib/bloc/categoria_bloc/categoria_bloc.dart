import 'package:bloc/bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_state.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    
    on<CategoriaInitEvent>(_onInit);
    on<CreateCategoriaEvent>(_onCreateCategoria);
    on<UpdateCategoriaEvent>(_onUpdateCategoria);
    on<DeleteCategoriaEvent>(_onDeleteCategoria);// Manejador para el nuevo evento

  }

  Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    
    emit(CategoriaLoading());

    try {
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to load categories: ${e.toString()}'));
    }
  }
  Future<void> _onCreateCategoria(CreateCategoriaEvent event,Emitter<CategoriaState> emit,) async {
    try {
      await categoriaRepository.crearCategoria(event.categoria);
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al crear categoría: ${e.toString()}'));
    }
  }
    Future<void> _onUpdateCategoria(UpdateCategoriaEvent event, Emitter<CategoriaState> emit,) async {
    try {
      emit(CategoriaLoading());
      await categoriaRepository.editarCategoria(event.categoria.id ?? '',event.categoria);
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al actualizar: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategoria(DeleteCategoriaEvent event, Emitter<CategoriaState> emit) async {
    try {
      emit(CategoriaLoading());
      await categoriaRepository.eliminarCategoria(event.categoriaId);
      final categoriasActualizadas = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al eliminar: ${e.toString()}'));
    }
  }
}