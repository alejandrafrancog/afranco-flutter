import 'package:flutter/material.dart';
import 'package:afranco/components/auth/auth_text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AuthTextField(
              key: const ValueKey('username_field'),
              controller: usernameController,
              labelText: 'Usuario',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El campo Usuario es obligatorio';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            AuthTextField(
              key: const ValueKey('password_field'),
              controller: passwordController,
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El campo Contraseña es obligatorio';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
