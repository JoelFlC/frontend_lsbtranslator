import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  
  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = '';

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  bool get speechEnabled => _speechEnabled;

  SpeechController() {
    _initSpeech();
  }

  /// Inicializa el plugin y solicita permisos.
  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            notifyListeners();
          }
        },
        onError: (errorNotification) {
          debugPrint('Speech error: ${errorNotification.errorMsg}');
          _isListening = false;
          notifyListeners();
        },
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error inicializando speech_to_text: $e");
    }
  }

  /// Comienza a escuchar el micrófono y actualiza el texto en tiempo real.
  Future<void> startListening() async {
    if (!_speechEnabled) {
      // Reintentar inicializar si falló antes (ej. por permisos)
      await _initSpeech();
      if (!_speechEnabled) return;
    }
    
    _recognizedText = '';
    _isListening = true;
    notifyListeners();

    await _speechToText.listen(
      onResult: (result) {
        _recognizedText = result.recognizedWords;
        notifyListeners();
      },
      localeId: 'es_ES', // Asumiendo Español como idioma principal
    );
  }

  /// Detiene la escucha manualmente.
  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }
}
