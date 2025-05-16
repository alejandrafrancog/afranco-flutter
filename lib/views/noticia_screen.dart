import 'package:afranco/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/helpers/error_helper.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:afranco/views/preferencia_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/components/noticia_error.dart';
import 'package:afranco/components/noticia_card.dart';
import 'package:afranco/components/noticia_loading.dart';
import 'package:afranco/components/noticia_empty_state.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/components/noticia_creation_modal.dart';
import 'package:intl/intl.dart';
import 'package:afranco/components/noticia_edit_modal.dart';
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
  late final NoticiaBloc _noticiaBloc = context.read<NoticiaBloc>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticiaBloc>().add(NoticiaCargadaEvent());
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<NoticiaBloc>().add(NoticiaCargarMasEvent());
      //_noticiaBloc.add(NoticiaCargarMasEvent());
    }
  }

  void _abrirModalEdicion(Noticia noticia) {
    showDialog(
      context: context,
      builder:
          (context) => NoticiaEditModal(
            noticia: noticia,
            id: noticia.id,
            onNoticiaUpdated: () {
              // Force refresh after edit
              if (mounted) {
                _noticiaBloc.add(NoticiaRecargarEvent());
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
              // Force refresh after creation
              if (!mounted) {return;}
                _noticiaBloc.add(NoticiaRecargarEvent());
              
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferenciaState = context.watch<PreferenciaBloc>().state;
    final filtrosActivos = preferenciaState.categoriasSeleccionadas.isNotEmpty;

    return BlocProvider.value(
      value:_noticiaBloc,
      //create: (context) => NoticiaBloc()..add(NoticiaCargadaEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                    color: filtrosActivos ? Colors.amber : null,
                  ),
                  tooltip: 'Preferencias',
                  onPressed: () {
                    Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreferenciasScreen(),
                      ),
                    ).then((categoriasSeleccionadas) {
                      if (!context.mounted) return;

                      // Always reload after returning from preferences screen
                      if (categoriasSeleccionadas != null) {
                        if (categoriasSeleccionadas.isNotEmpty) {
                          // Apply category filter
                          context.read<NoticiaBloc>().add(
                            FilterNoticiasByPreferencias(
                              categoriasSeleccionadas,
                            ),
                          );
                        } else {
                          // No categories selected, load all news
                          context.read<NoticiaBloc>().add(
                            NoticiaCargadaEvent(),
                          );
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            body: BlocConsumer<NoticiaBloc, NoticiaState>(
              listener: (context, state) {
                if (state is NoticiaErrorState) {
                  final error = state.error;

                  if (error is ApiException) {
                    final errorData = ErrorHelper.getErrorMessageAndColor(
                      error.statusCode,
                    );
                    final message =
                        errorData['message'] ?? 'Error desconocido.';
                    final color = errorData['color'] ?? Colors.grey;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message), backgroundColor: color),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ocurrió un error inesperado.'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }
                }
              },

              builder: (context, state) {
                return Column(
                  children: [
                    // Sección de última actualización
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
                    // Lista de noticias
                    Expanded(child: _buildBodyContent(state)),
                  ],
                );
              },
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: _mostrarModalCreacion,
              child: const Icon(Icons.add),
            ),
          );
        },
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

      if (index < 0 || index >= state.noticias.length) {
        return const SizedBox.shrink();
      }

      return NoticiaCard(
        noticia: state.noticias[index],
        imageUrl: state.noticias[index].urlImagen,
        onEditPressed: _abrirModalEdicion,
        onDelete: () {
          // Make sure to reload news after deletion
          context.read<NoticiaBloc>().add(NoticiaRecargarEvent());
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
    _noticiaBloc.close();
    super.dispose();
  }
}
