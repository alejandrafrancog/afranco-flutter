import 'package:afranco/domain/noticia.dart';
import 'package:equatable/equatable.dart';

class NoticiaState extends Equatable {
  final List<Noticia> noticias;
  final bool tieneMas;
  final DateTime? ultimaActualizacion;
  final bool isLoading;

  const NoticiaState({
    this.noticias = const [],
    this.tieneMas = true,
    this.ultimaActualizacion,
    this.isLoading = false,
  });

  NoticiaState copyWith({
    List<Noticia>? noticias,
    bool? tieneMas,
    DateTime? ultimaActualizacion,
    bool? isLoading,
  }) {
    return NoticiaState(
      noticias: noticias ?? this.noticias,
      tieneMas: tieneMas ?? this.tieneMas,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [noticias, tieneMas, ultimaActualizacion, isLoading];
}

class NoticiaLoadingState extends NoticiaState {
  const NoticiaLoadingState({
    required super.noticias,
    required super.tieneMas,
    required super.ultimaActualizacion,
  }) : super(
          isLoading: true,
        );
}

class NoticiasLoaded extends NoticiaState {
  const NoticiasLoaded({
    required super.noticias,
    required super.tieneMas,
    required DateTime super.ultimaActualizacion,
    super.isLoading,
  });
}

// Estados específicos para operaciones CRUD
class NoticiasLoadedAfterCreate extends NoticiasLoaded {
  const NoticiasLoadedAfterCreate(
    List<Noticia> noticias,
    DateTime ultimaActualizacion, {
    super.tieneMas = false,
    super.isLoading,
  }) : super(
          noticias: noticias,
          ultimaActualizacion: ultimaActualizacion,
        );
}

class NoticiasLoadedAfterEdit extends NoticiasLoaded {
  const NoticiasLoadedAfterEdit(
    List<Noticia> noticias,
    DateTime ultimaActualizacion, {
    super.tieneMas = false,
    super.isLoading,
  }) : super(
          noticias: noticias,
          ultimaActualizacion: ultimaActualizacion,
        );
}

class NoticiasLoadedAfterDelete extends NoticiasLoaded {
  const NoticiasLoadedAfterDelete(
    List<Noticia> noticias,
    DateTime ultimaActualizacion, {
    super.tieneMas = false,
    super.isLoading,
  }) : super(
          noticias: noticias,
          ultimaActualizacion: ultimaActualizacion,
        );
}

class NoticiasLoadedAfterRefresh extends NoticiasLoaded {
  const NoticiasLoadedAfterRefresh(
    List<Noticia> noticias,
    DateTime ultimaActualizacion, {
    super.tieneMas = false,
    super.isLoading,
  }) : super(
          noticias: noticias,
          ultimaActualizacion: ultimaActualizacion,
        );
}

class NoticiaErrorState extends NoticiaState {
  final dynamic error;

   const NoticiaErrorState({
    required this.error,
    required super.noticias,
    required super.tieneMas,
    required super.ultimaActualizacion,
  }) : super(
          isLoading: false,
        );

  @override
  List<Object?> get props => [error, noticias, tieneMas, ultimaActualizacion, isLoading];
}