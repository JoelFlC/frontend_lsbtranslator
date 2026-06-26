import 'package:frontend_lsbtranslator/services/sign_service.dart';

class MockSignService implements SignService {
  @override
  Future<List<String>> translateTextToLsbUrls(String text) async {
    // Simulamos un retraso de red (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    // Devolvemos una lista de URLs de video simulando diferentes señas.
    // Usaremos algunos videos públicos genéricos como placeholders.
    // En el sistema real, estos serían los clips pregrabados por el actor.
    return [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Simular una tercera seña
    ];
  }
}
