class ApiException implements Exception {
  final String? message;
  final int? statusCode;
  final DateTime timestamp;

  ApiException( {
    required this.message,
    required this.statusCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '$message: (Código: $statusCode)';
}
