import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';

class VideoPlayerZone extends StatelessWidget {
  const VideoPlayerZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoQueueController>(
      builder: (context, controller, child) {
        if (!controller.isPlayingSequence || controller.currentPlayer == null) {
          // Estado Idle o esperando inicialización
          return Container(
            color: Colors.black87,
            child: const Center(
              child: Icon(
                Icons.video_library_rounded,
                color: Colors.white54,
                size: 80,
              ),
            ),
          );
        }

        return Container(
          color: Colors.black, // Fondo negro para transiciones
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.currentPlayer!.value.aspectRatio,
              child: VideoPlayer(controller.currentPlayer!),
            ),
          ),
        );
      },
    );
  }
}
