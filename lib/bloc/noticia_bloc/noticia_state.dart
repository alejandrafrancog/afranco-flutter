import 'package:afranco/domain/noticia.dart';
import 'package:flutter/material.dart';
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
class NoticiasLoaded extends NoticiaState {
  final List<Noticia> noticiasList;
  final DateTime lastUpdated;

  NoticiasLoaded(this.noticiasList, this.lastUpdated);

}
class NoticiasError extends NoticiaState {
  
  final String errorMessage;
  final int? statusCode;

  NoticiasError(this.errorMessage, {this.statusCode});

}
class NoticiaLoadingState extends NoticiaState {
  NoticiaLoadingState({
    required super.noticias,
    required super.tieneMas,
    super.ultimaActualizacion,
  }) : super(
          isLoading: true,
        );
}

class NoticiaErrorState extends NoticiaState {
  final Object error; 

  NoticiaErrorState({required this.error, required super.noticias, required super.tieneMas, super.ultimaActualizacion,
  });
}
