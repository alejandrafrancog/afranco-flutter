import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstants {
  // Configuración de Noticias
  static String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static String get newsApiUrl => dotenv.env['NEWS_API_URL'] ?? '';
  static String get curlApiUrl => dotenv.env['CURL_API_URL'] ?? '';
  static int get newsPageSize => int.tryParse(dotenv.env['NEWS_PAGE_SIZE'] ?? '') ?? 10;
  static String get language => dotenv.env['NEWS_LANGUAGE'] ?? 'es';
  static String get category => dotenv.env['NEWS_CATEGORY'] ?? 'tecnología';
}