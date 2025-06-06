import 'package:afranco/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:afranco/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/constants/constants.dart';

/// Widget que muestra una alerta cuando no hay conectividad a Internet usando SnackBar
class ConnectivityAlert extends StatelessWidget {
  const ConnectivityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) {
        // Solo actuar cuando hay un cambio real en el estado de conectividad
        return (previous is ConnectivityConnected && current is ConnectivityDisconnected) || 
               (previous is ConnectivityDisconnected && current is ConnectivityConnected);
      },
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          // Mostrar SnackBar persistente cuando se desconecta
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  ApiConstants.errorNoInternet,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(days: 1), // Virtualmente infinito
              ),
            );
        } else if (state is ConnectivityConnected) {
          // Ocultar SnackBar cuando se recupera la conexión
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
      child: const SizedBox.shrink(), // Widget invisible
    );
  }
}
