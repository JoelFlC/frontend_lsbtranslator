import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';

class SubtitleZone extends StatelessWidget {
  const SubtitleZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateController>(
      builder: (context, controller, child) {
        String displayText = "";
        
        switch (controller.currentState) {
          case AppState.idle:
            displayText = "Presiona el micrófono o escribe una frase";
            break;
          case AppState.processing:
            displayText = "Traduciendo: ${controller.currentText}...";
            break;
          case AppState.playing:
            final queueController = context.watch<VideoQueueController>();
            displayText = queueController.currentClip?.textEquivalent ?? controller.currentText;
            break;
        }

        return Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              key: ValueKey(controller.currentState),
              children: [
                if (controller.currentState == AppState.processing)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                Expanded(
                  child: Text(
                    displayText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
