import 'package:flutter/material.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_colors.dart';

class QuickPhraseCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: isDark ? colorScheme.surfaceContainerLow : colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isDark ? colorScheme.tertiary : colorScheme.onSecondaryContainer,
                size: 28,
              ),
              const SizedBox(height: 12),
              Text(
                text,
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
    );
  }
}
