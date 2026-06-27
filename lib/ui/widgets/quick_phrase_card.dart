import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_colors.dart';

class QuickPhraseCard extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const QuickPhraseCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<QuickPhraseCard> createState() => _QuickPhraseCardState();
}

class _QuickPhraseCardState extends State<QuickPhraseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark 
              ? (_isHovered ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerLow)
              : (_isHovered ? colorScheme.secondaryContainer.withValues(alpha: 0.7) : colorScheme.secondaryContainer),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark 
                ? (_isHovered ? colorScheme.tertiary.withValues(alpha: 0.5) : colorScheme.surfaceContainerHighest)
                : (_isHovered ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.surfaceContainerHigh),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: isDark ? colorScheme.tertiary : colorScheme.onSecondaryContainer,
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? colorScheme.onSurface : colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
