import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_state.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_event.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_state.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/helpers/snackbar_helper.dart';

class PreferenciasScreen extends StatelessWidget {
  const PreferenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Preferencias'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () => context.read<PreferenciaBloc>().add(
            const ReiniciarFiltros(),
          ),
          tooltip: 'Restablecer filtros',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, categoriaState) => _buildCategoriaContent(context, categoriaState),
    );
  }

  Widget _buildCategoriaContent(BuildContext context, CategoriaState categoriaState) {
    return switch (categoriaState) {
      CategoriaLoading() => const Center(child: CircularProgressIndicator()),
      CategoriaError(:final message) => _buildErrorWidget(
          context,
          'Error al cargar categorías: $message',
          () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
        ),
      CategoriaLoaded(:final categorias) => _buildPreferenciaContent(context, categorias),
      _ => const Center(child: Text('Estado desconocido')),
    };
  }

  Widget _buildPreferenciaContent(BuildContext context, List<Categoria> categorias) {
    return BlocBuilder<PreferenciaBloc, PreferenciaState>(
      builder: (context, preferenciasState) => _buildPreferenciaStateContent(
        context, 
        preferenciasState, 
        categorias,
      ),
    );
  }

  Widget _buildPreferenciaStateContent(
    BuildContext context,
    PreferenciaState preferenciasState,
    List<Categoria> categorias,
  ) {
    return switch (preferenciasState) {
      PreferenciaLoading() => _buildLoadingIndicator(),
      PreferenciaError(:final mensaje) => _buildErrorWidget(
          context,
          'Error de preferencias: $mensaje',
          () => context.read<PreferenciaBloc>().add(const CargarPreferencias()),
        ),
      _ => _buildListaCategorias(context, preferenciasState, categorias),
    };
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando preferencias...'),
        ],
      ),
    );
  }

  Widget _buildListaCategorias(
    BuildContext context,
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _buildCategoriaItem(
        context,
        categorias[index],
        state,
      ),
    );
  }

  Widget _buildCategoriaItem(
    BuildContext context,
    Categoria categoria,
    PreferenciaState state,
  ) {
    final isSelected = state.categoriasSeleccionadas.contains(categoria.id);
    final isEnabled = state is! PreferenciaLoading;

    return CheckboxListTile(
      title: Text(
        categoria.nombre,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        categoria.descripcion,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: isSelected,
      onChanged: isEnabled 
          ? (_) => _toggleCategoria(context, categoria.id ?? '', isSelected)
          : null,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<PreferenciaBloc, PreferenciaState>(
      builder: (context, state) => BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusText(context, state),
              _buildApplyButton(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, PreferenciaState state) {
    final isError = state is PreferenciaError;
    final text = isError
        ? 'Error al cargar preferencias'
        : 'Categorías seleccionadas: ${state.categoriasSeleccionadas.length}';
    
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isError ? Colors.red : null,
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, PreferenciaState state) {
    final isEnabled = state is! PreferenciaError;
    
    return ElevatedButton(
      style: NoticiaEstilos.estiloBotonPrimario(context),
      onPressed: isEnabled ? () => _aplicarFiltros(context, state) : null,
      child: const Text('Aplicar filtros'),
    );
  }

  void _toggleCategoria(
    BuildContext context,
    String categoriaId,
    bool isSelected,
  ) {
    context.read<PreferenciaBloc>().add(
      CambiarCategoria(categoria: categoriaId, seleccionada: !isSelected),
    );
  }

  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    if (state is PreferenciaError) {
      SnackBarHelper.showSnackBar(
        context,
        'No se pueden aplicar los filtros debido a un error',
      );
      return;
    }

    context.read<PreferenciaBloc>().add(
      SavePreferencias(categoriasSeleccionadas: state.categoriasSeleccionadas),
    );

    final message = state.categoriasSeleccionadas.isEmpty
        ? 'Mostrando todas las noticias'
        : 'Filtros aplicados correctamente';

    SnackBarHelper.showSuccess(context, message);
    Navigator.pop(context, state.categoriasSeleccionadas);
  }

  Widget _buildErrorWidget(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}