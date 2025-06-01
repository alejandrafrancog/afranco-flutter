import 'package:afranco/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/helpers/error_helper.dart';
import 'package:afranco/helpers/snackbar_helper.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:afranco/views/preferencia_screen.dart';
import 'package:flutter/material.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/components/noticia/noticia_error.dart';
import 'package:afranco/components/noticia/noticia_card.dart';
import 'package:afranco/components/noticia/noticia_loading.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/components/noticia/noticia_creation_modal.dart';
import 'package:intl/intl.dart';
import 'package:afranco/components/noticia/noticia_edit_modal.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';

class NoticiaScreen extends StatefulWidget {
  final NoticiaRepository repository = NoticiaRepository();
  NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Usar el nuevo evento que carga automáticamente las preferencias
      if (mounted) {
        context.read<NoticiaBloc>().add(CargarNoticiasConPreferenciasEvent());
      }
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentOffset = _scrollController.position.pixels;

    if (currentOffset > _lastScrollOffset + 20) {
      if (_showFab && mounted) setState(() => _showFab = false);
    } else if (currentOffset < _lastScrollOffset - 20) {
      if (!_showFab && mounted) setState(() => _showFab = true);
    }

    _lastScrollOffset = currentOffset;
  }

  void _abrirModalEdicion(Noticia noticia) {
    showDialog(
      context: context,
      builder:
          (context) => NoticiaEditModal(
            noticia: noticia,
            id: noticia.id ?? '',
            onNoticiaUpdated: () {
              if (mounted) {
                context.read<NoticiaBloc>().add(NoticiaEditedEvent());
              }
            },
          ),
    );
  }

  void _mostrarModalCreacion() {
    showDialog(
      context: context,
      builder:
          (context) => NoticiaCreationModal(
            service: widget.repository,
            onNoticiaCreated: (_) {
              if (mounted) {
                context.read<NoticiaBloc>().add(NoticiaCreatedEvent());
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferenciaState = context.watch<PreferenciaBloc>().state;
    // ✅ Revisar si hay filtros activos tanto en preferencias como en el bloc de noticias
    final noticiaBloc = context.read<NoticiaBloc>();
    final filtrosActivos =
        preferenciaState.categoriasSeleccionadas.isNotEmpty ||
        noticiaBloc.tienesFiltrosActivos;

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ReporteBloc())],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            NoticiaConstants.appTitle,
            style: NoticiaEstilos.tituloAppBar,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(
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
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
                // ✅ Cambiar color visual cuando hay filtros activos
                color: filtrosActivos ? Colors.amber : Colors.white,
              ),
              tooltip: filtrosActivos ? 'Filtros activos' : 'Preferencias',
              onPressed: () {
                Navigator.push<List<String>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferenciasScreen(),
                  ),
                ).then((categoriasSeleccionadas) {
                  if (!mounted) return;
                  if (categoriasSeleccionadas != null) {
                    // ✅ Siempre aplicar el filtro, incluso si está vacío
                    context.read<NoticiaBloc>().add(
                      FilterNoticiasByPreferencias(categoriasSeleccionadas),
                    );
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refrescar',
              color: Colors.white,
              onPressed: () {
                // ✅ Usar el evento de recarga que respeta filtros
                context.read<NoticiaBloc>().add(NoticiaRecargarEvent());
              },
            ),
            // ✅ Botón adicional para limpiar filtros
            if (filtrosActivos)
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Limpiar filtros',
                color: Colors.white,
                onPressed: () {
                  // Limpiar filtros y cargar todas las noticias
                  context.read<NoticiaBloc>().add(
                    FilterNoticiasByPreferencias([]),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Filtros limpiados - Mostrando todas las noticias',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
          ],
        ),
        body: BlocListener<ReporteBloc, ReporteState>(
          listener: (context, state) {
            if (state is ReporteLoadedWithMessage) {
              SnackBarHelper.showSuccess(context, state.message);
            }
          },
          child: BlocConsumer<NoticiaBloc, NoticiaState>(
            listener: (context, state) {
              // Manejo de errores
              if (state is NoticiaErrorState) {
                final error = state.error;
                if (error is ApiException) {
                  final errorData = ErrorHelper.getErrorMessageAndColor(
                    error.statusCode,
                  );
                  final message = errorData['message'] ?? 'Error desconocido.';
                  SnackBarHelper.showSnackBar(
                    context,
                    message,
                    statusCode: error.statusCode,
                  );
                } else {
                  SnackBarHelper.showClientError(
                    context,
                    'Ocurrió un error inesperado.',
                  );
                }
                return;
              }

              // Manejo específico por tipo de operación
              if (state is NoticiasLoadedAfterCreate) {
                SnackBarHelper.showCreateSuccess(context);
              } else if (state is NoticiasLoadedAfterEdit) {
                SnackBarHelper.showEditSuccess(context);
              } else if (state is NoticiasLoadedAfterDelete) {
                SnackBarHelper.showDeleteSuccess(context);
              } else if (state is NoticiasLoadedAfterRefresh) {
                SnackBarHelper.showRefreshSuccess(
                  context,
                  state.noticias.length,
                );
              } else if (state is NoticiasLoaded && !state.isLoading) {
                // Para carga inicial o casos no específicos
                final noticiaBloc = context.read<NoticiaBloc>();
                final mensaje =
                    noticiaBloc.tienesFiltrosActivos
                        ? 'Filtros aplicados: ${state.noticias.length} noticias'
                        : 'Cargadas ${state.noticias.length} noticias';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(mensaje),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // ✅ Indicador visual de filtros activos
                  if (filtrosActivos)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      color: Colors.amber.shade100,
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Colors.amber.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Filtros activos - ${state.noticias.length} noticias',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    color: Colors.grey[300],
                    child:
                        state.ultimaActualizacion != null
                            ? Text(
                              'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(state.ultimaActualizacion!)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  Expanded(child: _buildBodyContent(state)),
                ],
              );
            },
          ),
        ),
        floatingActionButton:
            _showFab
                ? FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'Agregar noticia',
                  onPressed: _mostrarModalCreacion,
                  child: const Icon(Icons.add),
                )
                : null,
      ),
    );
  }

  Widget _buildBodyContent(NoticiaState state) {
    if (state.isLoading && state.noticias.isEmpty) {
      return const FullScreenLoading();
    }
    if (state is NoticiaErrorState) {
      return ErrorMessage(
        message: state.error.toString(),
        onRetry:
            () => context.read<NoticiaBloc>().add(
              CargarNoticiasConPreferenciasEvent(),
            ),
      );
    }
    if (state.noticias.isEmpty) {
      // ✅ Mensaje diferente si hay filtros activos pero no hay resultados
      final noticiaBloc = context.read<NoticiaBloc>();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              noticiaBloc.tienesFiltrosActivos
                  ? Icons.filter_list_off
                  : Icons.article_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left:79,right:35,top: 15,bottom: 29),
              child: Text(
                noticiaBloc.tienesFiltrosActivos
                    ? 'No hay noticias que coincidan con los filtros seleccionados.'
                    : 'No hay noticias disponibles en este momento.',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
              ),
            ),
            if (noticiaBloc.tienesFiltrosActivos) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  context.read<NoticiaBloc>().add(
                    FilterNoticiasByPreferencias([]),
                  );
                },
                icon: const Icon(Icons.clear),
                label: const Text('Limpiar filtros'),
              ),
            ],
          ],
        ),
      );
    }
    return ListView.separated(
      controller: _scrollController,
      itemCount: state.noticias.length + (state.tieneMas ? 1 : 0),
      separatorBuilder:
          (_, __) => const SizedBox(height: NoticiaEstilos.espaciadoAlto),
      itemBuilder: (context, index) {
        if (index >= state.noticias.length) {
          return _buildLoadingIndicator(state.isLoading);
        }
        return NoticiaCard(
          noticia: state.noticias[index],
          imageUrl: state.noticias[index].urlImagen,
          onEditPressed: _abrirModalEdicion,
          onDelete: () {
            context.read<NoticiaBloc>().add(NoticiaDeletedEvent());
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return Visibility(
      visible: isLoading,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
