import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_state.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';
import 'package:afranco/components/mixins/scroll_fab_mixin.dart';
import 'package:afranco/components/noticia/noticia_app_bar.dart';
import 'package:afranco/components/noticia/noticia_filter_indicator.dart';
import 'package:afranco/components/noticia/noticia_list_body.dart';
import 'package:afranco/components/noticia/modales/noticia_creation_modal.dart';
import 'package:afranco/components/noticia/modales/noticia_edit_modal.dart';
import 'package:afranco/helpers/noticia_filter_helper.dart';
import 'package:afranco/helpers/snackbar_helper.dart';
import 'package:afranco/helpers/error_helper.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/exceptions/api_exception.dart';

class NoticiaScreen extends StatefulWidget {
  final NoticiaRepository repository = NoticiaRepository();
  
  NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> 
    with ScrollFabMixin<NoticiaScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NoticiaBloc>().add(CargarNoticiasConPreferenciasEvent());
      }
    });
    initializeScrollListener();
  }

  void _abrirModalEdicion(Noticia noticia) {
    showDialog(
      context: context,
      builder: (context) => NoticiaEditModal(
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
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ReporteBloc())],
      child: BlocBuilder<NoticiaBloc, NoticiaState>(
        builder: (context, state) {
          final filtrosActivos = NoticiaFilterHelper.tienesFiltrosActivos(context);
          
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: NoticiaAppBar(filtrosActivos: filtrosActivos),
            body: _buildBody(state, filtrosActivos),
            floatingActionButton: showFab ? _buildFab(context) : null,
          );
        },
      ),
    );
  }

  Widget _buildBody(NoticiaState state, bool filtrosActivos) {
    return BlocListener<ReporteBloc, ReporteState>(
      listener: (context, reporteState) {
        if (reporteState is ReporteLoadedWithMessage) {
          SnackBarHelper.showSuccess(context, reporteState.message);
        }
      },
      child: BlocListener<NoticiaBloc, NoticiaState>(
        listener: _handleNoticiaStateChanges,
        child: Column(
          children: [
            if (filtrosActivos)
              NoticiaFilterIndicator(cantidadNoticias: state.noticias.length),
            _buildLastUpdateInfo(state),
            Expanded(
              child: NoticiaListBody(
                scrollController: scrollController,
                onEditPressed: _abrirModalEdicion,
                onDelete: () {
                  context.read<NoticiaBloc>().add(NoticiaDeletedEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdateInfo(NoticiaState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      tooltip: 'Agregar noticia',
      onPressed: _mostrarModalCreacion,
      child: const Icon(Icons.add),
    );
  }

  void _handleNoticiaStateChanges(BuildContext context, NoticiaState state) {
    if (state is NoticiaErrorState) {
      _handleError(context, state.error);
      return;
    }

    _handleSuccessStates(context, state);
  }

  void _handleError(BuildContext context, dynamic error) {
    if (error is ApiException) {
      final errorData = ErrorHelper.getErrorMessageAndColor(error.statusCode);
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
  }

  void _handleSuccessStates(BuildContext context, NoticiaState state) {
    if (state is NoticiasLoadedAfterCreate) {
      SnackBarHelper.showCreateSuccess(context);
    } else if (state is NoticiasLoadedAfterEdit) {
      SnackBarHelper.showEditSuccess(context);
    } else if (state is NoticiasLoadedAfterDelete) {
      SnackBarHelper.showDeleteSuccess(context);
    } else if (state is NoticiasLoadedAfterRefresh) {
      SnackBarHelper.showRefreshSuccess(context, state.noticias.length);
    } else if (state is NoticiasLoaded && !state.isLoading) {
      _showLoadedMessage(context, state);
    }
  }

  void _showLoadedMessage(BuildContext context, NoticiasLoaded state) {
    final noticiaBloc = context.read<NoticiaBloc>();
    final mensaje = NoticiaFilterHelper.getMensajeFiltros(
      state.noticias.length,
      noticiaBloc.tienesFiltrosActivos,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}