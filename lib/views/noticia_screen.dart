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
import 'package:afranco/components/noticia/noticia_empty_state.dart';
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
  // NO usar late final aquí, usar el bloc del contexto directamente
  bool _showFab = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Asegurar que el widget esté montado antes de disparar eventos
      if (mounted) {
        context.read<NoticiaBloc>().add(NoticiaCargadaEvent());
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
      builder: (context) => NoticiaEditModal(
        noticia: noticia,
        id: noticia.id,
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
      builder: (context) => NoticiaCreationModal(
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
    final filtrosActivos = preferenciaState.categoriasSeleccionadas.isNotEmpty;

    return MultiBlocProvider(
      providers: [
        // Usar BlocProvider.value para reutilizar el bloc existente
        BlocProvider.value(value: context.read<NoticiaBloc>()),
        BlocProvider(create: (_) => ReporteBloc()),
      ],
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
                color: filtrosActivos ? Colors.white : Colors.white,
              ),
              tooltip: 'Preferencias',
              onPressed: () {
                Navigator.push<List<String>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferenciasScreen(),
                  ),
                ).then((categoriasSeleccionadas) {
                  if (!mounted) return;
                  if (categoriasSeleccionadas != null) {
                    if (categoriasSeleccionadas.isNotEmpty) {
                      context.read<NoticiaBloc>().add(
                        FilterNoticiasByPreferencias(categoriasSeleccionadas),
                      );
                    } else {
                      context.read<NoticiaBloc>().add(NoticiaCargadaEvent());
                    }
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refrescar',
              color: Colors.white,
              onPressed: () {
                final categoriasSeleccionadas =
                    context.read<PreferenciaBloc>().state.categoriasSeleccionadas;
                if (categoriasSeleccionadas.isNotEmpty) {
                  context.read<NoticiaBloc>().add(
                    FilterNoticiasByPreferencias(categoriasSeleccionadas),
                  );
                } else {
                  context.read<NoticiaBloc>().add(NoticiaCargadaEvent());
                }
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
                SnackBarHelper.showLoadSuccess(context, state.noticias.length);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    color: Colors.grey[300],
                    child: state.ultimaActualizacion != null
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
        floatingActionButton: _showFab
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
        onRetry: () => context.read<NoticiaBloc>().add(NoticiaRecargarEvent()),
      );
    }
    if (state.noticias.isEmpty) {
      return const EmptyState();
    }
    return ListView.separated(
      controller: _scrollController,
      itemCount: state.noticias.length + (state.tieneMas ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: NoticiaEstilos.espaciadoAlto),
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