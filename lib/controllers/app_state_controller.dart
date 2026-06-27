import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/models/sign_clip.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';

enum AppState { idle, processing, playing }

class AppStateController extends ChangeNotifier {
  AppState _currentState = AppState.idle;
  String _currentText = "";
  List<SignClip> _currentClips = [];

  final SignService _signService = locator<SignService>();

  AppState get currentState => _currentState;
  String get currentText => _currentText;
  List<SignClip> get currentClips => _currentClips;

  void setIdle() {
    _currentState = AppState.idle;
    notifyListeners();
  }

  void _setProcessing(String text) {
    _currentState = AppState.processing;
    _currentText = text;
    notifyListeners();
  }

  void setPlaying(List<SignClip> clips) {
    _currentState = AppState.playing;
    _currentClips = clips;
    notifyListeners();
  }

  Future<void> processText(String text) async {
    if (text.trim().isEmpty) return;

    _setProcessing(text);

    try {
      final clips = await _signService.translateTextToSignClips(text);
      if (clips.isNotEmpty) {
        setPlaying(clips);
      } else {
        // Fallback si no hay traducciones
        setIdle();
      }
    } catch (e) {
      debugPrint("Error al procesar el texto: $e");
      setIdle(); // Regresamos a idle en caso de error
    }
  }
}
