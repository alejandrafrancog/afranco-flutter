import 'dart:async';

class MockAuthService {
  Future<bool> login(String username, String password) async {

    if (username.isEmpty || password.isEmpty) {
      print('Error: Usuario o contraseña no pueden estar vacíos.');
      return false;
    }

    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

