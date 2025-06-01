import 'package:flutter/material.dart';
import 'package:afranco/noticias_estilos.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: isLoading
          ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(179),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              style: NoticiaEstilos.estiloBotonInicioSesion(context).copyWith(
                elevation: WidgetStateProperty.all(4),
                shadowColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 3, 65, 65).withAlpha(77),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              onPressed: onPressed,
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
