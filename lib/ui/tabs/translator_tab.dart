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

  Widget _buildCurrentView(BuildContext context, AppStateController controller) {
    if (controller.currentState == AppState.idle || controller.currentState == AppState.processing) {
      return TranslatorInputView(
        key: const ValueKey('input_view'),
        onSubmit: (text) => _handleProcessText(context, text),
      );
    } else {
      return const TranslatorPlayerView(
        key: ValueKey('player_view'),
      );
    }
  }
}
