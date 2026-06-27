import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class TranslatorPlayerView extends StatelessWidget {
  const TranslatorPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video Container
          Container(
            height: MediaQuery.of(context).size.height * 0.75, // Aumentado para formato vertical
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // The actual video player
                Consumer<VideoQueueController>(
                  builder: (context, controller, child) {
                    if (controller.currentPlayer == null) {
                      return Center(
                        child: CircularProgressIndicator(color: colorScheme.secondary),
                      );
                    }
                    return SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.currentPlayer!.value.size.width,
                          height: controller.currentPlayer!.value.size.height,
                          child: VideoPlayer(controller.currentPlayer!),
                        ),
                      ),
                    );
                  },
                ),
                
                // LSB Activo Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'En vivo',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Botón de Cerrar / Volver
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: colorScheme.onSurface),
                      tooltip: 'Cerrar y volver al inicio',
                      onPressed: () {
                        context.read<VideoQueueController>().stopAndClear();
                        context.read<AppStateController>().setIdle();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Media Controls Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Consumer<VideoQueueController>(
                builder: (context, queue, child) {
                  final isPlaying = queue.currentPlayer?.value.isPlaying ?? false;
                  final speed = queue.playbackSpeed;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón Restart
                      IconButton(
                        icon: Icon(Icons.replay, color: colorScheme.onSurfaceVariant),
                        onPressed: () {
                          queue.restartSequence();
                        },
                      ),
                      
                      // Botón Play/Pause
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow, 
                            color: colorScheme.onTertiary, 
                            size: 32
                          ),
                          onPressed: () {
                            queue.togglePlayPause();
                          },
                        ),
                      ),
                      
                      // Botón Speed
                      TextButton(
                        onPressed: () {
                          queue.cycleSpeed();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        child: Text('${speed}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // Transcript Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.closed_caption_outlined, color: colorScheme.secondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TRADUCCIÓN CONFIRMADA',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer2<AppStateController, VideoQueueController>(
                    builder: (context, appState, queue, child) {
                      final displayText = queue.currentClip?.textEquivalent ?? appState.currentText;
                      return Text(
                        '"$displayText"',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
