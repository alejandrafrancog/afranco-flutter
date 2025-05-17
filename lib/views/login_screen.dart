import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/auth_bloc/auth_bloc.dart';
import 'package:afranco/bloc/auth_bloc/auth_event.dart';
import 'package:afranco/bloc/auth_bloc/auth_state.dart';
import 'package:afranco/views/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navegación a la pantalla de bienvenida cuando el usuario está autenticado
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(
                ),
              ),
            );
          } else if (state is AuthFailure) {
            // Mostrar mensaje de error en caso de fallo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título con emoji y estilo mejorado
                  Text(
                    "🔐 Iniciar Sesión",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 26),
                  
                  // Campo de Usuario
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El campo Usuario es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Contraseña
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El campo Contraseña es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón de Iniciar Sesión con estado de carga
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            // Validar el formulario
                            if (_formKey.currentState?.validate() ?? false) {
                              // Mostrar snackbar de "Iniciando sesión..."
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Iniciando sesión...')),
                              );
                              
                              final username = _usernameController.text.trim();
                              final password = _passwordController.text.trim();

                              // Dispara el evento de login al BLoC
                              context.read<AuthBloc>().add(
                                    AuthLoginRequested(
                                      email: username,
                                      password: password,
                                    ),
                                  );
                            }
                          },
                          child: const Text('Iniciar Sesión'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}