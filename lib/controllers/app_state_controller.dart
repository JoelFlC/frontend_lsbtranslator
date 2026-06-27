import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/models/sign_clip.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';

enum AppState { idle, processing, playing, error }

class AppStateController extends ChangeNotifier {
  AppState _currentState = AppState.idle;
  String _currentText = "";
  List<SignClip> _currentClips = [];
  final List<String> _history = [];
  String _errorMessage = "";
  
  final SignService _signService = locator<SignService>();

  AppState get currentState => _currentState;
  String get currentText => _currentText;
  List<SignClip> get currentClips => _currentClips;
  List<String> get history => _history;
  String get errorMessage => _errorMessage;

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

  void setError(String message) {
    _currentState = AppState.error;
    _errorMessage = message;
    notifyListeners();
    
    // Regresar a idle automáticamente después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentState == AppState.error) {
        setIdle();
      }
    });
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
      final clips = await _signService.translateText(text);
      
      if (clips.isNotEmpty) {
        setPlaying(clips);
      } else {
        setError("No se encontró una traducción para esta frase.");
      }
    } catch (e) {
      debugPrint("Error fatal al procesar el texto: $e");
      setError("No pudimos conectar con el servidor en este momento.");
    }
  }
}