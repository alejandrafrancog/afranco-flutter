import 'package:afranco/api/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:afranco/views/welcome_screen.dart'; // Ajusta la ruta según tu estructura

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final MockAuthService _authService = MockAuthService();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Iniciando sesión...')));

    final success = await _authService.login(username, password);
    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso.')),
      );
      // Redirige a WelcomeScreen después del login exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en el inicio de sesión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "🔐 Iniciar Sesión",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 26),
            TextField(
              controller: _usernameController,

              decoration: const InputDecoration(
                labelText: 'Usuario',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,

              decoration: const InputDecoration(
                labelText: 'Contraseña',

                border: OutlineInputBorder(),
              ),

              obscureText: true,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _login,

              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
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
