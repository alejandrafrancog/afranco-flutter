abstract class TareaContadorEvent {}

class IncrementarContador extends TareaContadorEvent {}

class DecrementarContador extends TareaContadorEvent {}

class SetTotalTareas extends TareaContadorEvent {
  final int total;
  SetTotalTareas(this.total);
}

class ActualizarContadores extends TareaContadorEvent {
  final int completadas;
  final int total;
  ActualizarContadores(this.completadas, this.total);
}
