import 'package:afranco/bloc/auth_bloc/auth_bloc.dart';
import 'package:afranco/bloc/auth_bloc/auth_state.dart';
import 'package:afranco/components/welcome/welcome_body.dart';
import 'package:afranco/components/welcome/welcome_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
      ),
      drawer: WelcomeDrawer(username: username),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String username = '';
          if (state is AuthAuthenticated) {
            username = username;
          }

          return const WelcomeBody();
        },
      ),
    );
  }

}
