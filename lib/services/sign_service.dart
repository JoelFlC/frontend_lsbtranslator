import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend_lsbtranslator/models/sign_clip.dart'; // Import único y limpio

class SignService {
  // ATENCIÓN: Si cambiaste a un nuevo proyecto de Firebase,
  // pega aquí la NUEVA URL que te dio el despliegue.
  static const String _functionUrl =
      'https://translatetolsb-b5uu5qpcxq-uc.a.run.app';

  // EL PLAN Z: JSON local de contingencia (Actualizado a la nueva BD)
  static const Map<String, List<Map<String, dynamic>>> _planZ = {
    "buenos días como le puedo ayudar": [
      {
        "id": "E6ZhdwJPaTSyBi06Sf1E",
        "videoUrl": "assets/videos/buenos_dias_ayudar.mp4",
        "textEquivalent": "Buenos días como le puedo ayudar",
      },
    ],
    "por favor espere su turno": [
      {
        "id": "HIN1uN1nTQADSdj9hkv1",
        "videoUrl": "assets/videos/espere_turno.mp4",
        "textEquivalent": "Por favor espere su turno",
      },
    ],
    "muchas gracias hasta luego": [
      {
        "id": "HyhqPcmx6MTAPJpGKmWl",
        "videoUrl": "assets/videos/gracias_hasta_luego.mp4",
        "textEquivalent": "Muchas gracias hasta luego",
      },
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
          // MAPEO BLINDADO A PRUEBA DE ERRORES
          final clips = (data['clips'] as List).map((clip) {
            final rawUrl = clip['videoUrl'] ?? '';
            final cleanUrl = rawUrl
                .replaceAll('"', '')
                .replaceAll("'", "")
                .trim();
            return SignClip(
              conceptId: clip['id'] ?? clip['conceptId'] ?? 'desconocido',
              videoUrl: cleanUrl,
              textEquivalent: clip['text'] ?? clip['id'] ?? 'Señal',
            );
          }).where((clip) => !clip.videoUrl.contains('ejemplo.com') && !clip.videoUrl.contains('fallback.mp4')).toList();
          
          if (clips.isNotEmpty) {
            return clips;
          } else {
            throw Exception('El servidor devolvió enlaces inválidos o vacíos');
          }
        }
      }
      // Si el servidor responde un error 500 o similar, forzamos caída al Plan Z
      throw Exception('Error del servidor: ${response.statusCode}');
    } catch (e) {
      // 2. CONTINGENCIA: Si no hay internet o el servidor falla, entra el Plan Z
      print('=== ALERTA: Activando Plan Z de contingencia ===');
      print('Error detectado: $e');

      if (_planZ.containsKey(cleanText)) {
        return _planZ[cleanText]!
            .map((clip) => SignClip.fromJson(clip))
            .toList();
      }

      // Si falla todo y la frase no está en el Plan Z, devolvemos un fallback seguro
      return [
        SignClip(
          conceptId: 'no_disponible',
          videoUrl:
              'https://res.cloudinary.com/djtvg1k6l/video/upload/v1782567426/no_disponible_wggxtq.mp4',
          textEquivalent: 'Señal no disponible', // Requerido por tu modelo
        ),
      ];
    }
  }
}
