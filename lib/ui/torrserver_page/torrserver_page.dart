import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/ui/torrserver_page/settings_field_generator.dart';
import 'package:torrstv/ui/torrserver_page/ts_meta.dart';
import 'package:torrstv/ui/torrserver_page/ts_settings_provider.dart';

class TorrServerPage extends ConsumerWidget {
  const TorrServerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final settingsAsyncValue = ref.watch(torrServerSettingsFutureProvider);
    final tsHost = ref.read(settingsProvider).getTSHost();

    return Scaffold(
      appBar: AppBar(title: const Text('TorrServer Settings'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: settingsAsyncValue.when(
            loading: () => const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Загрузка настроек...')]),
            ),

            error: (err, stack) => Center(
              child: Text(
                'Error: ${err.toString()}',
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

            data: (initialSettings) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(torrServerSettingsNotifierProvider.notifier).initialize(initialSettings);
              });

              final currentSettings = ref.watch(torrServerSettingsNotifierProvider);

              final fieldsToGenerate = <Widget>[];

              for (final key in currentSettings.keys) {
                final metadata = torrServerMetadata[key];

                if (metadata != null) {
                  fieldsToGenerate.add(SettingsFieldGenerator(settingKey: key, value: currentSettings[key], label: metadata.label, hint: metadata.hint));
                }
              }

              return ListView(
                children: [
                  ref
                      .watch(torrServerVersionProvider)
                      .when(
                        loading: () => const SizedBox(height: 24),
                        error: (e, s) => Text('Error: ${e.toString()}', style: TextStyle(color: colorScheme.error)),
                        data: (v) => Text('TorrServer version: $v, $tsHost', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  const Divider(height: 40),

                  ...fieldsToGenerate,

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final saved = await ref.read(torrServerSettingsNotifierProvider.notifier).saveSettings();
                      if (saved) {
                        messenger.showSnackBar(const SnackBar(content: Text('Settings saved successful')));
                      } else {
                        messenger.showSnackBar(const SnackBar(content: Text('Save Settings fault')));
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Send settings'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
