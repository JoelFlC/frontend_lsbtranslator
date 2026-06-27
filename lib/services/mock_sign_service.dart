import 'package:frontend_lsbtranslator/models/sign_clip.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';

class MockSignService implements SignService {
  @override
  Future<List<SignClip>> translateText(String text) async {
    // Simulamos un retraso de red (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    // Devolvemos una lista de SignClips simulando diferentes señas.
    return [
      SignClip(
        conceptId: 'c_001',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        textEquivalent: 'Mariposa',
      ),
      SignClip(
        conceptId: 'c_002',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        textEquivalent: 'Abeja',
      ),
      SignClip(
        conceptId: 'c_003',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        textEquivalent: 'Volando',
      ),
    ];
  }
}
