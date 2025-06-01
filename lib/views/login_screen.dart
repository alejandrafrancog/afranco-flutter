import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/auth_bloc/auth_bloc.dart';
import 'package:afranco/bloc/auth_bloc/auth_event.dart';
import 'package:afranco/bloc/auth_bloc/auth_state.dart';
import 'package:afranco/views/welcome_screen.dart';
import 'package:afranco/components/auth/login_header.dart';
import 'package:afranco/components/auth/login_form.dart';
import 'package:afranco/components/auth/login_button.dart';
import 'package:afranco/helpers/snackbar_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      SnackBarHelper.showLoginProgress(context);
      
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: username,
          password: password,
        ),
      );
    }
  }

  void _navigateToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _navigateToWelcome();
          } else if (state is AuthFailure) {
            SnackBarHelper.showError(context, state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.08),
                      
                      const LoginHeader(),
                      
                      SizedBox(height: size.height * 0.06),
                      
                      LoginForm(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      LoginButton(
                        onPressed: _handleLogin,
                        isLoading: state is AuthLoading,
                        width: size.width * 0.8,
                      ),
                      
                      SizedBox(height: size.height * 0.1),
                    ],
                  ),
                ),
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
