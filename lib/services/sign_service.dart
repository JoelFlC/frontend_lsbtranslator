import 'package:frontend_lsbtranslator/models/sign_clip.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/sign_clip.dart'; // Asumiendo que el modelo se llama así

class SignService {
  // Tu URL de producción (HT-9)
  static const String _functionUrl =
      'https://translatetolsb-b5uu5qpcxq-uc.a.run.app';

  // EL PLAN Z: JSON local de contingencia (HT-10)
  static const Map<String, List<Map<String, dynamic>>> _planZ = {
    "pase a ventanilla": [
      {"id": "pase", "video_url": "assets/videos/pase.mp4"},
      {"id": "ventanilla", "video_url": "assets/videos/ventanilla.mp4"},
    ],
    "su documento está incompleto": [
      {"id": "documento", "video_url": "assets/videos/documento.mp4"},
      {"id": "incompleto", "video_url": "assets/videos/incompleto.mp4"},
    ],
    "tome turno": [
      {"id": "tomar", "video_url": "assets/videos/tomar.mp4"},
      {"id": "turno", "video_url": "assets/videos/turno.mp4"},
    ],
  };

  Future<List<SignClip>> translateText(String text) async {
    final cleanText = text.toLowerCase().trim();

    try {
      // 1. Intentar golpear el servidor orquestador
      final response = await http
          .post(
            Uri.parse(_functionUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'text': cleanText}),
          )
          .timeout(const Duration(seconds: 10)); // Timeout preventivo

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['clips'] != null) {
          final clips = (data['clips'] as List)
              .map((clip) => SignClip.fromJson(clip))
              .where((clip) => !clip.videoUrl.contains('ejemplo.com') && !clip.videoUrl.contains('fallback.mp4'))
              .toList();
          
          if (clips.isNotEmpty) {
            return clips;
          } else {
            // Si todos los clips devueltos eran erróneos, forzamos caída al error
            throw Exception('El servidor devolvió enlaces inválidos');
          }
        }
      }
      // Si el servidor responde un error 500 o similar, forzamos caída al Plan Z
      throw Exception('Error del servidor');
    } catch (e) {
      // 2. CONTINGENCIA: Si no hay internet o el servidor falla, entra el Plan Z
      print('=== ALERTA: Activando Plan Z de contingencia ===');
      print('Error detectado: $e');

      if (_planZ.containsKey(cleanText)) {
        return _planZ[cleanText]!
            .map((clip) => SignClip.fromJson(clip))
            .toList();
      }

      // Si falla todo y la frase no está en el Plan Z, devolvemos una lista vacía
      // para que el controlador dispare el estado de Error en la UI
      return [];
    }
  }
}
