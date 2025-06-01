import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:afranco/helpers/noticia_filter_helper.dart';

class NoticiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool filtrosActivos;

  const NoticiaAppBar({
    Key? key,
    required this.filtrosActivos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        NoticiaConstants.appTitle,
        style: NoticiaEstilos.tituloAppBar,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        _buildCategoriaButton(context),
        _buildFiltroButton(context),
        _buildRefreshButton(context),
        if (filtrosActivos) _buildClearFiltersButton(context),
      ],
    );
  }

  Widget _buildCategoriaButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.category),
      tooltip: 'Categorías',
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoriaScreen(),
          ),
        );
      },
    );
  }

  Widget _buildFiltroButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.filter_list,
        color: filtrosActivos ? Colors.amber : Colors.white,
      ),
      tooltip: filtrosActivos ? 'Filtros activos' : 'Preferencias',
      onPressed: () => NoticiaFilterHelper.navegarAPreferencias(context),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Refrescar',
      color: Colors.white,
      onPressed: () {
        context.read<NoticiaBloc>().add(NoticiaRecargarEvent());
      },
    );
  }

  Widget _buildClearFiltersButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear),
      tooltip: 'Limpiar filtros',
      color: Colors.white,
      onPressed: () => NoticiaFilterHelper.limpiarFiltros(context),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
