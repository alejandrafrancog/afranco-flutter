import 'dart:async';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/core/api_config.dart';
import 'package:afranco/domain/login_request.dart';
import 'package:afranco/domain/login_response.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:flutter/material.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      debugPrint('🔐 Intentando login con usuario: ${request.username}');
      debugPrint(
        '🌐 URL: ${ApiConfig.beeceptorBaseUrl}${ApiConstantes.loginEndpoint}',
      );

      final data = await post(
        ApiConstantes.loginEndpoint,
        data: request.toJson(),
      );

      debugPrint('✅ Login exitoso');
      return LoginResponseMapper.fromMap(data);
    } catch (e) {
      debugPrint('❌ Error en login: $e');
      rethrow;
    }
  }
}
