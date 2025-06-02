
import 'package:equatable/equatable.dart';
import 'package:afranco/domain/categoria.dart';

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
