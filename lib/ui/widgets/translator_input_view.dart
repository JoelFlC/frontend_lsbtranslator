import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/speech_controller.dart';
import 'package:frontend_lsbtranslator/ui/widgets/quick_phrase_card.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_colors.dart';

class TranslatorInputView extends StatefulWidget {
  final Function(String) onSubmit;

  const TranslatorInputView({super.key, required this.onSubmit});

  @override
  State<TranslatorInputView> createState() => _TranslatorInputViewState();
}

class _TranslatorInputViewState extends State<TranslatorInputView> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isListening = false;

  SpeechController? _speechController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Start idle breathing animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_speechController == null) {
      _speechController = context.read<SpeechController>();
      _speechController!.addListener(_onSpeechChange);
    }
  }

  void _onSpeechChange() {
    if (_speechController!.isListening && _speechController!.recognizedText.isNotEmpty) {
      _textController.text = _speechController!.recognizedText;
    }
    
    final isListeningNow = _speechController!.isListening;
    if (_isListening != isListeningNow) {
      setState(() {
        _isListening = isListeningNow;
        if (_isListening) {
          _pulseController.duration = const Duration(milliseconds: 500);
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.duration = const Duration(seconds: 2);
          _pulseController.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _speechController?.removeListener(_onSpeechChange);
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _submitText(String text) {
    if (text.trim().isNotEmpty) {
      widget.onSubmit(text);
      _textController.clear();
    }
  }

  void _toggleListening() {
    if (_speechController!.isListening) {
      _speechController!.stopListening();
    } else {
      _textController.clear();
      _speechController!.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    minLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'Escriba aquí el mensaje para el cliente...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0 / 150',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      ElevatedButton(
                        onPressed: () => _submitText(_textController.text),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(140, 40),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Generar LSB'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Microphone Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening 
                              ? colorScheme.tertiaryContainer.withValues(alpha: 0.3)
                              : colorScheme.surfaceContainerHigh,
                          ),
                          child: Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isListening ? colorScheme.tertiary : colorScheme.tertiary, // Ensure it's tertiary (Teal) even when not listening
                              ),
                              child: Icon(
                                Icons.mic, 
                                color: colorScheme.onTertiary, 
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isListening ? 'Escuchando...' : 'Toque para hablar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _isListening ? colorScheme.tertiary : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          
          // Quick Phrases Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frases Rápidas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('Ver más', style: TextStyle(color: colorScheme.secondary)),
                    Icon(Icons.chevron_right, size: 16, color: colorScheme.secondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Grid of Phrases
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 130, // Aumentado a 130 para evitar overflow en web/textos largos
            ),
            children: [
              QuickPhraseCard(
                text: 'Buenos días, bienvenido.',
                icon: Icons.waving_hand_outlined,
                onTap: () => _submitText('Buenos días, bienvenido.'),
              ),
              QuickPhraseCard(
                text: 'Tome asiento, por favor.',
                icon: Icons.chair_alt_outlined,
                onTap: () => _submitText('Tome asiento, por favor.'),
              ),
              QuickPhraseCard(
                text: 'Diríjase al 2do piso.',
                icon: Icons.elevator_outlined,
                onTap: () => _submitText('Diríjase al 2do piso.'),
              ),
              QuickPhraseCard(
                text: 'Su carnet de identidad.',
                icon: Icons.badge_outlined,
                onTap: () => _submitText('Su carnet de identidad, por favor.'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
