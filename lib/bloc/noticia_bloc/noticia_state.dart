import 'dart:ui';
import 'package:afranco/domain/noticia.dart';

class NoticiaState {
  final List<Noticia> noticias;
  final bool tieneMas;
  final DateTime? ultimaActualizacion;
  final bool isLoading;
  final String? errorMessage;
  final Color? errorColor;

  NoticiaState({
    this.noticias = const [],
    this.tieneMas = true,
    this.ultimaActualizacion,
    this.isLoading = false,
    this.errorMessage,
    this.errorColor,
  });

  NoticiaState copyWith({
    List<Noticia>? noticias,
    bool? tieneMas,
    DateTime? ultimaActualizacion,
    bool? isLoading,
    String? errorMessage,
    Color? errorColor,
  }) {
    return NoticiaState(
      noticias: noticias ?? this.noticias,
      tieneMas: tieneMas ?? this.tieneMas,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      errorColor: errorColor ?? this.errorColor,
    );
  }
}

class NoticiaLoadingState extends NoticiaState {
  NoticiaLoadingState({
    required List<Noticia> noticias,
    required bool tieneMas,
    DateTime? ultimaActualizacion,
  }) : super(
          noticias: noticias,
          tieneMas: tieneMas,
          ultimaActualizacion: ultimaActualizacion,
          isLoading: true,
        );
}

class NoticiaErrorState extends NoticiaState {
  final Object error; // guardamos el error

  NoticiaErrorState({
    required this.error,
    required List<Noticia> noticias,
    required bool tieneMas,
    DateTime? ultimaActualizacion,
  }) : super(
    noticias: noticias,
    tieneMas: tieneMas,
    ultimaActualizacion: ultimaActualizacion,
  );
}
