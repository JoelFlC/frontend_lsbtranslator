import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';
import 'package:frontend_lsbtranslator/ui/widgets/translator_input_view.dart';
import 'package:frontend_lsbtranslator/ui/widgets/translator_player_view.dart';

class TranslatorTab extends StatelessWidget {
  const TranslatorTab({super.key});

  void _handleProcessText(BuildContext context, String text) async {
    final appState = context.read<AppStateController>();
    final videoQueue = context.read<VideoQueueController>();

    await appState.processText(text);

    if (appState.currentClips.isNotEmpty) {
      await videoQueue.playSequence(appState.currentClips);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateController>(
      builder: (context, controller, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentView(context, controller),
        );
      },
    );
  }

  Widget _buildCurrentView(
    BuildContext context,
    AppStateController controller,
  ) {
    // Si está en 'idle' o 'processing', mostramos la zona de entrada (o el spinner)
    if (controller.currentState == AppState.processing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // ¡Aquí está el spinner de la HT-9!
            SizedBox(height: 20),
            Text("Traduciendo con IA...", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (controller.currentState == AppState.idle) {
      return TranslatorInputView(
        onSubmit: (text) => _handleProcessText(context, text),
      );
    }

    if (controller.currentState == AppState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                "¡Ups!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // Si está en 'playing', mostramos el reproductor
    return const TranslatorPlayerView();
  }
}
