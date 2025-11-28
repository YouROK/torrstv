import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/ui/torrserver_page/settings_field_generator.dart';
import 'package:torrstv/ui/torrserver_page/ts_meta.dart';
import 'package:torrstv/ui/torrserver_page/ts_settings_provider.dart';

class TorrServerPage extends ConsumerWidget {
  const TorrServerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final settingsAsyncValue = ref.watch(torrServerSettingsFutureProvider);
    final tsHost = ref.read(settingsProvider).getTSHost();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.torrServerSettingsTitle), backgroundColor: colorScheme.surface, elevation: 0),
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
                l10n.errorLabel(err.toString()),
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

            data: (initialSettings) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(torrServerSettingsNotifierProvider.notifier).initialize(initialSettings);
              });

              final currentSettings = ref.watch(torrServerSettingsNotifierProvider);
              final metadata = getTorrServerMetadata(l10n);

              final fieldsToGenerate = <Widget>[];

              for (final key in currentSettings.keys) {
                final meta = metadata[key];
                if (meta != null) {
                  fieldsToGenerate.add(SettingsFieldGenerator(settingKey: key, value: currentSettings[key], label: meta.label, hint: meta.hint));
                }
              }

              return ListView(
                children: [
                  ref
                      .watch(torrServerVersionProvider)
                      .when(
                        loading: () => const SizedBox(height: 24),
                        error: (e, s) => Text(l10n.errorLabel(e.toString()), style: TextStyle(color: colorScheme.error)),
                        data: (v) => Text(l10n.torrServerVersion(v, tsHost), style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  const Divider(height: 40),

                  ...fieldsToGenerate,

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final saved = await ref.read(torrServerSettingsNotifierProvider.notifier).saveSettings();
                      if (saved) {
                        messenger.showSnackBar(SnackBar(content: Text(l10n.settingsSavedSuccess)));
                      } else {
                        messenger.showSnackBar(SnackBar(content: Text(l10n.settingsSavedError)));
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(l10n.sendSettingsButton),
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
