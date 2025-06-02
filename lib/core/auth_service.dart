import 'dart:async';
import 'package:afranco/domain/login_request.dart';
import 'package:afranco/domain/login_response.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dynamic data;
      final List<LoginRequest> usuariosTest = [
        const LoginRequest(username: 'profeltes', password: 'sodep'),
        const LoginRequest(username: 'Moni', password: 'sodep'),
        const LoginRequest(username: 'sodep', password: 'sodep'),
        const LoginRequest(username: 'visitante', password: 'sodep'),
      ];

      // Verificar si las credenciales coinciden con algún usuario de prueba
      bool credencialesValidas = usuariosTest.any(
        (usuario) =>
            usuario.username == request.username &&
            usuario.password == request.password,
      );
       if (credencialesValidas) {
        data = await postUnauthorized('/login', data: request.toJson());
      }

      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException(message:'Error de autenticación: respuesta vacía',statusCode: null);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(message:'Error en login',statusCode: null);
      }
    }
  }
}
