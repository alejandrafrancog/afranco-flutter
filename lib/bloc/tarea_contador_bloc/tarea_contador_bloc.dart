import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_event.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(TareaContadorState()) {
    on<IncrementarContador>(_onIncrementarContador);
    on<DecrementarContador>(_onDecrementarContador);
    on<SetTotalTareas>(_onSetTotalTareas);
    on<ActualizarContadores>(_onActualizarContadores);
  }

  void _onIncrementarContador(IncrementarContador event, Emitter<TareaContadorState> emit) {
    emit(state.copyWith(tareasCompletadas: state.tareasCompletadas + 1));
  }

  void _onDecrementarContador(DecrementarContador event, Emitter<TareaContadorState> emit) {
    final newCount = state.tareasCompletadas - 1;
    emit(state.copyWith(tareasCompletadas: newCount < 0 ? 0 : newCount));
  }

  void _onSetTotalTareas(SetTotalTareas event, Emitter<TareaContadorState> emit) {
    emit(state.copyWith(totalTareas: event.total));
  }

  void _onActualizarContadores(ActualizarContadores event, Emitter<TareaContadorState> emit) {
    emit(state.copyWith(
      tareasCompletadas: event.completadas,
      totalTareas: event.total,
    ));
  }
}
