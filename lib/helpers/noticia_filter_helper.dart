import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/views/preferencia_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';

class NoticiaFilterHelper {
  static bool tienesFiltrosActivos(BuildContext context) {
    final preferenciaState = context.watch<PreferenciaBloc>().state;
    final noticiaBloc = context.read<NoticiaBloc>();
    
    return preferenciaState.categoriasSeleccionadas.isNotEmpty ||
           noticiaBloc.tienesFiltrosActivos;
  }

  static void limpiarFiltros(BuildContext context) {
    context.read<NoticiaBloc>().add(
      FilterNoticiasByPreferencias([]),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtros limpiados - Mostrando todas las noticias'),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void navegarAPreferencias(BuildContext context) {
    Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const PreferenciasScreen(),
      ),
    ).then((categoriasSeleccionadas) {
      if (categoriasSeleccionadas != null) {
        context.read<NoticiaBloc>().add(
          FilterNoticiasByPreferencias(categoriasSeleccionadas),
        );
      }
    });
  }

  static String getMensajeFiltros(int cantidadNoticias, bool tienesFiltros) {
    return tienesFiltros
        ? 'Filtros aplicados: $cantidadNoticias noticias'
        : 'Cargadas $cantidadNoticias noticias';
  }
}
