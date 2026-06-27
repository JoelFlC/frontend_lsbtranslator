import 'package:frontend_lsbtranslator/models/sign_clip.dart';

abstract class SignService {
  /// Traduce texto en español a una lista de SignClips en LSB.
  Future<List<SignClip>> translateTextToSignClips(String text);
}
