import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';

enum AppState { idle, processing, playing }

class AppStateController extends ChangeNotifier {
  AppState _currentState = AppState.idle;
  String _currentText = "";
  List<String> _currentVideoUrls = [];

  final SignService _signService = locator<SignService>();

  AppState get currentState => _currentState;
  String get currentText => _currentText;
  List<String> get currentVideoUrls => _currentVideoUrls;

  void setIdle() {
    _currentState = AppState.idle;
    notifyListeners();
  }

  void _setProcessing(String text) {
    _currentState = AppState.processing;
    _currentText = text;
    notifyListeners();
  }

  void setPlaying(List<String> urls) {
    _currentState = AppState.playing;
    _currentVideoUrls = urls;
    notifyListeners();
  }

  Future<void> processText(String text) async {
    if (text.trim().isEmpty) return;

    _setProcessing(text);

    try {
      final urls = await _signService.translateTextToLsbUrls(text);
      if (urls.isNotEmpty) {
        setPlaying(urls);
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
