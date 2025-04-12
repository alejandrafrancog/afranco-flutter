import 'dart:async';

class MockAuthService {
  Future<bool> login(String username, String password) async {
    // Verifica que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      print('Error: Usuario o contraseña no pueden estar vacíos.');
      return false;
    }

    // Simula un retraso para imitar una llamada a un servicio real
    await Future.delayed(Duration(seconds: 1));

    // Imprime las credenciales en la consola
    // Retorna true para simular un login exitoso
    return true;
  }
}

void main() async {
  final authService = MockAuthService();

  // Simula un login
  final success = await authService.login('usuario_prueba', 'contrasena123');
  if (success) {
    print('Login exitoso');
  } else {
    print('Login fallido');
  }
}
