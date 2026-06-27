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

    if (appState.currentClips.isNotEmpty) {
      await videoQueue.playSequence(appState.currentClips);
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
                        'TRÁMITES Y CUENTAS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PhraseItem(
                    text: '¿Tiene su cédula de identidad?',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, '¿Tiene su cédula de identidad?'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Su documento está incompleto.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Su documento está incompleto.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Necesita una fotocopia.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Necesita una fotocopia.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Por favor firme aquí.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Por favor firme aquí.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Su saldo es insuficiente.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Su saldo es insuficiente.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: '¿Cuál es su monto?',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, '¿Cuál es su monto?'),
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
                    text: 'Buenos días, ¿cómo le puedo ayudar?',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Buenos días, ¿cómo le puedo ayudar?'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Muchas gracias, hasta luego.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Muchas gracias, hasta luego.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Por favor espere su turno.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Por favor espere su turno.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Por favor tome asiento.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Por favor tome asiento.'),
                  ),
                  const SizedBox(height: 8),
                  _PhraseItem(
                    text: 'Venir a la ventanilla.',
                    isGrey: true,
                    onPlay: () => _playPhrase(context, 'Venir a la ventanilla.'),
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

class _PhraseItem extends StatefulWidget {
  final String text;
  final bool isGrey;
  final VoidCallback onPlay;

  const _PhraseItem({
    required this.text,
    this.isGrey = false,
    required this.onPlay,
  });

  @override
  State<_PhraseItem> createState() => _PhraseItemState();
}

class _PhraseItemState extends State<_PhraseItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Background color logic
    Color baseColor = widget.isGrey 
        ? colorScheme.surfaceContainerLow 
        : Colors.transparent;
    
    Color hoverColor = isDark 
        ? colorScheme.surfaceContainerHighest 
        : colorScheme.surfaceContainerHigh;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered ? hoverColor : baseColor,
          borderRadius: BorderRadius.circular(12),
          border: widget.isGrey 
              ? Border.all(color: _isHovered ? colorScheme.outlineVariant : (isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerHigh)) 
              : Border.all(color: _isHovered ? colorScheme.primary : colorScheme.outlineVariant),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPlay,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
