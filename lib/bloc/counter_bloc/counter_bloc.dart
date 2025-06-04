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
    emit(_createCounterState(newCount));
  }

  void _onDecrement(DecrementCounter event, Emitter<CounterState> emit) {
    final newCount = state.count - 1;
    emit(_createCounterState(newCount));
  }

  void _onReset(ResetCounter event, Emitter<CounterState> emit) {
    emit(CounterState.initial());
  }

  CounterState _createCounterState(int count) {
    return CounterState(
      count: count,
      message: _getMessageForCount(count),
      color: _getColorForCount(count),
    );
  }

  String _getMessageForCount(int count) {
    if (count > 0) {
      return 'Contador en positivo';
    } else if (count < 0) {
      return 'Contador en negativo';
    } else {
      return 'Contador en cero';
    }
  }

  Color _getColorForCount(int count) {
    if (count > 0) {
      return Colors.green;
    } else if (count < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}