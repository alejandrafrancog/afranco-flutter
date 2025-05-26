class TareaContadorState {
  final int tareasCompletadas;
  final int totalTareas;

  TareaContadorState({this.tareasCompletadas = 0, this.totalTareas = 0});

  double get progreso =>
      totalTareas > 0 ? tareasCompletadas / totalTareas : 0.0;

  TareaContadorState copyWith({int? tareasCompletadas, int? totalTareas}) {
    return TareaContadorState(
      tareasCompletadas: tareasCompletadas ?? this.tareasCompletadas,
      totalTareas: totalTareas ?? this.totalTareas,
    );
  }
}
