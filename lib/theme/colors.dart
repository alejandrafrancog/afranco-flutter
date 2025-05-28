import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios corporativos SODEP
  static const Color primary = Color.fromRGBO(16, 73, 138, 1); // Azul corporativo principal
  static const Color primaryLight = Color.fromRGBO(0, 108, 181, 1); // Azul corporativo claro
  static const Color primaryDark = Color.fromRGBO(16, 73, 138, 1);
  
  // Colores secundarios
  static const Color secondary = Color.fromRGBO(0, 108, 181, 1); // Azul corporativo claro
  static const Color secondaryLight = Color.fromRGBO(0, 108, 181, 0.8);
  static const Color secondaryDark = Color.fromRGBO(16, 73, 138, 1);
  
  // Color corporativo gris
  static const Color corporateGrey = Color.fromRGBO(137, 137, 137, 1);
  
  // Colores de fondo
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  
  // Colores de acento - basados en la paleta corporativa
  static const Color accent = Color.fromRGBO(0, 108, 181, 1); // Azul claro como acento
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0EA5E9);
  
  // Colores neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);
  
  // Colores específicos para valores sodepianos - basados en la paleta corporativa
  static const Color honestidad = Color.fromRGBO(16, 73, 138, 1); // Azul principal
  static const Color calidad = Color.fromRGBO(0, 108, 181, 1); // Azul claro
  static const Color flexibilidad = Color.fromRGBO(137, 137, 137, 1); // Gris corporativo
  static const Color comunicacion = Color.fromRGBO(16, 73, 138, 0.8); // Azul principal transparente
  static const Color autogestion = Color.fromRGBO(0, 108, 181, 0.8); // Azul claro transparente
}