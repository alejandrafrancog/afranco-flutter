/*import 'package:equatable/equatable.dart';
import 'package:afranco/domain/category.dart'; // Asegúrate de importar Categoria

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent {}

// Nuevo evento para creación de categorías
class CreateCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;
  
  CreateCategoriaEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}*/
import 'package:equatable/equatable.dart';
import 'package:afranco/domain/category.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent {}

class CreateCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;
  CreateCategoriaEvent(this.categoria);
  @override List<Object?> get props => [categoria];
}

class UpdateCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;
  UpdateCategoriaEvent(this.categoria);
  @override List<Object?> get props => [categoria];
}

class DeleteCategoriaEvent extends CategoriaEvent {
  final String categoriaId;
  DeleteCategoriaEvent(this.categoriaId);
  @override List<Object?> get props => [categoriaId];
}
