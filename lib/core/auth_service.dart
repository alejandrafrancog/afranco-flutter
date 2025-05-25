import 'dart:async';
import 'package:afranco/domain/login_request.dart';
import 'package:afranco/domain/login_response.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();
  
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final data = await post(
        '/login',
        data: request.toJson(),   
      );
      
      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException(message:'Error de autenticación: respuesta vacía',statusCode:404);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(message:'Error de conexión: ${e.toString()}',statusCode:500);
      }
    }
  }
}
