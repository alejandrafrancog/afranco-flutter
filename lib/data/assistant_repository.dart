class AssistantRepository {
  // Método para generar pasos basados en el título y la fecha límite
  Future<List<String>> generateSteps(String title, DateTime fechaLimite) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    final String fechaFormateada = '${fechaLimite.day.toString().padLeft(2, '0')}/'
        '${fechaLimite.month.toString().padLeft(2, '0')}/'
        '${fechaLimite.year}';
    return [
      'Paso 1: Planificar antes del $fechaFormateada',
      'Paso 2: Ejecutar $title',
      'Paso 3: Revisar $title',
    ];
  }
}