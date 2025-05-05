
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    on<IncrementCounter>(_onIncrement);
    on<DecrementCounter>(_onDecrement);
    on<ResetCounter>(_onReset);
  }
void _onIncrement(IncrementCounter event, Emitter<CounterState> emit) {
  final newCount = state.count + 1;
  emit(CounterState(
    count: newCount,
    message: newCount > 0 
      ? 'Contador en positivo' 
      : newCount < 0 
        ? 'Contador en negativo' 
        : 'Contador en cero',
    color: newCount > 0 
      ? Colors.green 
      : newCount < 0 
        ? Colors.red 
        : Colors.black,
  ));
}

void _onDecrement(DecrementCounter event, Emitter<CounterState> emit) {
  final newCount = state.count - 1;
  emit(CounterState(
    count: newCount,
    message: newCount > 0 
      ? 'Contador en positivo' 
      : newCount < 0 
        ? 'Contador en negativo' 
        : 'Contador en cero',
    color: newCount > 0 
      ? Colors.green 
      : newCount < 0 
        ? Colors.red 
        : Colors.black,
  ));
}
    void _onReset(ResetCounter event, Emitter<CounterState> emit) {
    emit(CounterState.initial());
  }


}
