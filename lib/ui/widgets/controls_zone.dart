import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ControlsZone extends StatefulWidget {
  final Function(String) onSubmitText;

  const ControlsZone({super.key, required this.onSubmitText});

  @override
  State<ControlsZone> createState() => _ControlsZoneState();
}

class _ControlsZoneState extends State<ControlsZone> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize(
      onError: (error) => debugPrint("Error STT: $error"),
    );
    setState(() {});
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            _textController.text = result.recognizedWords;
            if (result.finalResult) {
              _submit();
            }
          },
          localeId: 'es_BO', // Español de Bolivia (o general)
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _submit() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitText(text);
      _textController.clear();
      if (_isListening) {
        _speech.stop();
        setState(() => _isListening = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateController>(
      builder: (context, controller, child) {
        final isBusy = controller.currentState != AppState.idle;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isBusy ? 0 : null, // Ocultar si está ocupado
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Escribe una frase...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton.large(
                      onPressed: _listen,
                      backgroundColor: _isListening ? Colors.red : Theme.of(context).primaryColor,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
