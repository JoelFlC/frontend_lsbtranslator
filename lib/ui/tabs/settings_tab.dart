import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_colors.dart';
import 'package:frontend_lsbtranslator/controllers/theme_controller.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  double _speedValue = 1.0;
  bool _autoPlayVoice = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'Ajustes',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personaliza tu experiencia de traducción LSB',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Translation Speed Card
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 12),
                      Text(
                        'Translation Speed',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Adjust the signing speed of the avatar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.text_fields, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(height: 4),
                          Text('Slow', style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Theme.of(context).colorScheme.outlineVariant,
                            inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
                            thumbColor: Theme.of(context).colorScheme.primary,
                            overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            trackHeight: 4.0,
                          ),
                          child: Slider(
                            value: _speedValue,
                            min: 0.5,
                            max: 1.5,
                            divisions: 2,
                            onChanged: (value) {
                              setState(() {
                                _speedValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.cruelty_free, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(height: 4),
                          Text('Fast', style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                  const Center(
                    child: Text('Normal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // Toggles Card
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Auto-play voice
                  Row(
                    children: [
                      Icon(Icons.volume_up_outlined, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auto-play voice', style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              'Read translated text aloud automatically',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoPlayVoice,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            _autoPlayVoice = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest, height: 1),
                  const SizedBox(height: 16),
                  // Dark Mode
                  Consumer<ThemeController>(
                    builder: (context, themeController, child) {
                      return Row(
                        children: [
                          Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dark Mode', style: Theme.of(context).textTheme.titleMedium),
                                Text(
                                  'Switch to high-contrast theme',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: themeController.isDarkMode,
                            activeTrackColor: Theme.of(context).colorScheme.primary,
                            onChanged: (value) {
                              themeController.toggleTheme(value);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _speedValue = 1.0;
                      _autoPlayVoice = true;
                      context.read<ThemeController>().toggleTheme(false); // Default to light
                    });
                  },
                  child: const Text('Reset to Default'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ajustes guardados')),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
