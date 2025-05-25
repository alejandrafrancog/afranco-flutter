import 'package:afranco/bloc/connectivity_bloc/connectivity_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:afranco/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:afranco/components/connectivity/no_connection_view.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final bool requiresConnection;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.requiresConnection = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityDisconnected && requiresConnection) {
          return Scaffold(
            body: NoConnectionView(
              onRetry: () {
                context.read<ConnectivityBloc>().add(CheckConnectivity());
              },
            ),
          );
        }
        
        return child;
      },
    );
  }
}