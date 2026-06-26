import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  void _playPhrase(BuildContext context, String text) async {
    final appState = context.read<AppStateController>();
    final videoQueue = context.read<VideoQueueController>();

    await appState.processText(text);

    if (appState.currentVideoUrls.isNotEmpty) {
      await videoQueue.playSequence(appState.currentVideoUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar frases o historial...',
              prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 32),

          // Historial Reciente
          const _SectionHeader(title: 'Historial Reciente'),
          const SizedBox(height: 16),
          _PhraseItem(
            text: '¿Me puede dar su número de cuenta?',
            onPlay: () => _playPhrase(context, '¿Me puede dar su número de cuenta?'),
          ),
          const SizedBox(height: 8),
          _PhraseItem(
            text: 'El trámite demora 24 horas.',
            onPlay: () => _playPhrase(context, 'El trámite demora 24 horas.'),
          ),

          const SizedBox(height: 32),

          // Frases Rápidas
          const _SectionHeader(title: 'Frases Rápidas'),
          const SizedBox(height: 16),
          
          Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.transparent 
                : colorScheme.surfaceContainerLowest,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.surfaceContainerHigh,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 18, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'CUENTAS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PhraseItem(
                    text: '¿Desea consultar su saldo?',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, '¿Desea consultar su saldo?'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Por favor, su carnet de identidad.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Por favor, su carnet de identidad.'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.transparent 
                : colorScheme.surfaceContainerLowest,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.surfaceContainerHigh,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.support_agent_outlined, size: 18, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'ATENCIÓN AL CLIENTE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PhraseItem(
                    text: 'Buenos días, ¿en qué le puedo ayudar?',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Buenos días, ¿en qué le puedo ayudar?'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Espere un momento, por favor.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Espere un momento, por favor.'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 1),
      ],
    );
  }
}

class _PhraseItem extends StatelessWidget {
  final String text;
  final bool isGrey;
  final VoidCallback onPlay;

  const _PhraseItem({
    required this.text,
    this.isGrey = false,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isGrey 
            ? (isDark ? colorScheme.surfaceContainerLow : colorScheme.surfaceContainerLow) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isGrey ? null : Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_outlined,
                color: isDark ? colorScheme.tertiary : colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
