import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/models/sign_clip.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';

enum AppState { idle, processing, playing }

class AppStateController extends ChangeNotifier {
  AppState _currentState = AppState.idle;
  String _currentText = "";
  List<SignClip> _currentClips = [];
  final List<String> _history = [];
  
  final SignService _signService = locator<SignService>();

  AppState get currentState => _currentState;
  String get currentText => _currentText;
  List<SignClip> get currentClips => _currentClips;
  List<String> get history => _history;

  void setIdle() {
    _currentState = AppState.idle;
    notifyListeners();
  }

  void _setProcessing(String text) {
    // HT-9 Resuelto: Al cambiar a 'processing', la UI (el archivo principal)
    // solo tiene que leer este estado para mostrar el CircularProgressIndicator (Spinner)
    _currentState = AppState.processing;
    _currentText = text;
    notifyListeners();
  }

  void setPlaying(List<SignClip> clips) {
    _currentState = AppState.playing;
    _currentClips = clips;
    notifyListeners();
  }

  void _addToHistory(String text) {
    if (_history.contains(text)) {
      _history.remove(text);
    }
    _history.insert(0, text);
    if (_history.length > 3) {
      _history.removeLast();
    }
  }

  Future<void> processText(String text) async {
    if (text.trim().isEmpty) return;

    _addToHistory(text);
    _setProcessing(text);

    try {
      // Ajusté el nombre del método para que coincida exactamente con el
      // 'translateText' que definimos en el sign_service.dart (Plan Z)
      final clips = await _signService.translateText(text);
      
      if (clips.isNotEmpty) {
        setPlaying(clips); // Comienza la reproducción de videos
      } else {
        setIdle(); // Fallback si no hay traducciones
      }
    } catch (e) {
      debugPrint("Error fatal al procesar el texto: $e");
      // Ojo: Si el error llega hasta aquí, significa que falló internet (HT-9)
      // Y TAMBIÉN falló el Plan Z offline (HT-10). Devolvemos a idle para no bloquear la app.
      setIdle(); 
    }
  }
}