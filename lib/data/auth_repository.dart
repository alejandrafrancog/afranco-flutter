import 'package:afranco/core/auth_service.dart';
import 'package:afranco/core/secure_storage_service.dart';
import 'package:afranco/data/task_repository.dart';
import 'package:afranco/domain/login_response.dart';
import 'package:afranco/domain/login_request.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = di<SecureStorageService>();

  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }

      // Primero limpiar los datos del usuario anterior
      await _secureStorage.clearJwt();
      await _secureStorage.clearUserEmail();
      await di<TaskRepository>().limpiarCache();

      final loginRequest = LoginRequest(username: email, password: password);

      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
    await di<TaskRepository>().limpiarCache();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    // Siempre retorna false para forzar la pantalla de login
    return false;
  }

  // Get current auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}
