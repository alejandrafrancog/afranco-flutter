part of 'counter_bloc.dart';
class CounterState {
  final int count;
  final String message;
  final Color color;

  CounterState({required this.count,
  required this.message,
  required this.color});
  
  factory CounterState.initial(){
    return CounterState(
      count:0,
      message: 'Contador en cero',
      color: Colors.black,
    );
  }
}