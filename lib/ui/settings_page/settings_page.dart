import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:torrstv/core/constants/app_info.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/services/torrserver/ts.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/utils/platform_utils.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/l10n/locale_provider.dart';
import 'package:torrstv/ui/settings_page/download_dialog/dl_ts.dart';
import 'package:torrstv/ui/widgets/dpad_text_field.dart';

final _hostControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final currentHost = ref.watch(settingsProvider.select((s) => s.getTSHost()));
  final controller = TextEditingController(text: currentHost);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final _authControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final currentAuth = ref.watch(settingsProvider.select((s) => s.getTSAuth()));
  final controller = TextEditingController(text: currentAuth);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final _playerControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final currentPlayer = ref.watch(settingsProvider.select((s) => s.getOuterPlayer()));
  final controller = TextEditingController(text: currentPlayer);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final _isOuterPlayerEnabledLocalProvider = StateProvider.autoDispose<bool>((ref) {
  final initialValue = ref.watch(settingsProvider.select((s) => s.isOuterPlayerEnable()));
  return initialValue;
});

final _isSearchSaveProvider = StateProvider.autoDispose<bool>((ref) {
  final initialValue = ref.watch(settingsProvider.select((s) => s.isSearchSave()));
  return initialValue;
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  bool isShowDownloadTS() {
    return !PlatformUtils.isWeb;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsNotifier = ref.read(settingsProvider);
    final hostController = ref.watch(_hostControllerProvider);
    final authController = ref.watch(_authControllerProvider);
    final playerController = ref.watch(_playerControllerProvider);
    final isOuterPlayerEnabled = ref.watch(_isOuterPlayerEnabledLocalProvider);
    final isSearchSaveEnabled = ref.watch(_isSearchSaveProvider);

    final isOuterPlayerEnabledNotifier = ref.read(_isOuterPlayerEnabledLocalProvider.notifier);
    final isSearchSaveEnabledNotifier = ref.read(_isSearchSaveProvider.notifier);

    final currentLocale = ref.watch(localeProvider);
    String currentLanguageCode = '';
    currentLocale.when(
      data: (locale) {
        currentLanguageCode = locale.languageCode;
      },
      loading: () {},
      error: (err, stack) {},
    );

    final colorScheme = Theme.of(context).colorScheme;

    final showDownloadButton = isShowDownloadTS();

    String getCurrentDropdownValue() {
      final currentLocale = ref.watch(localeProvider);

      return currentLocale.maybeWhen(
        data: (locale) {
          final code = locale.languageCode;
          if (code == 'en' || code == 'ru') return code;
          return 'system';
        },
        orElse: () => 'system',
      );
    }

    void onLanguageChanged(String? value) {
      if (value == null) return;

      final localeNotifier = ref.read(localeProvider.notifier);
      localeNotifier.setLocale(value);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.languageChanged)));
    }

    void pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null) {
        String? filePath = result.files.single.path;

        if (filePath != null) {
          playerController.text = filePath;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              // Адрес ТС
              const SizedBox(height: 20),
              DpadTextField(
                controller: hostController,
                keyboardType: TextInputType.url,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: l10n.tsAddressLabel,
                  hintText: "http://127.0.0.1:8090",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.5),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ),

              // Аутентификация
              const SizedBox(height: 20),
              DpadTextField(
                controller: authController,
                keyboardType: TextInputType.url,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: l10n.tsAuthLabel,
                  hintText: l10n.tsAuthHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.5),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ),

              // Выбор плеера
              const SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(width: 5),
                  SizedBox(
                    width: 64,
                    child: Switch(
                      onChanged: (value) {
                        isOuterPlayerEnabledNotifier.state = value;
                      },
                      value: isOuterPlayerEnabled,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: DpadTextField(
                      controller: playerController,
                      keyboardType: TextInputType.url,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: l10n.selectPlayerLabel,
                        hintText: l10n.selectPlayerHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface.withOpacity(0.5),
                        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 64,
                    child: IconButton(onPressed: pickFile, icon: const Icon(Icons.folder_open)),
                  ),
                  SizedBox(width: 5),
                ],
              ),

              // Сохранять настройки поиска
              const SizedBox(height: 40),
              SwitchListTile(
                title: Text(l10n.rememberSearchParams),
                onChanged: (value) {
                  isSearchSaveEnabledNotifier.state = value;
                },
                value: isSearchSaveEnabled,
              ),

              // Кнопка сохранить
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  settingsNotifier.setTSHost(hostController.text);
                  settingsNotifier.setTSAuth(authController.text);
                  settingsNotifier.setOuterPlayer(playerController.text);
                  final newOuterPlayerEnableState = ref.read(_isOuterPlayerEnabledLocalProvider);
                  settingsNotifier.setOuterPlayerEnable(newOuterPlayerEnableState);
                  final newSearchSaveEnableState = ref.read(_isSearchSaveProvider);
                  settingsNotifier.setSearchSaveEnable(newSearchSaveEnableState);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
                },
                icon: const Icon(Icons.save),
                label: Text(l10n.saveSettings),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Выбор языка
              DropdownButtonFormField<String>(
                value: getCurrentDropdownValue(),
                decoration: InputDecoration(
                  labelText: l10n.language,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.5),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                items: [
                  DropdownMenuItem(value: 'system', child: Text(l10n.systemLanguage)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'ru', child: Text(l10n.russian)),
                ],
                onChanged: onLanguageChanged,
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              if (showDownloadButton) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    startDownloadDialog(context, ref);
                  },
                  icon: const Icon(Icons.download, size: 24),
                  label: Text(l10n.downloadTorrServerButton, style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final torrServerService = ref.read(torrServerServiceProvider);
                    final result = await torrServerService.startTorrServer();
                    if (context.mounted) {
                      if (result.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TorrServer started')));
                      }
                    }
                  },
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: Text(l10n.startTorrServerButton, style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(torrServerApiProvider).shutdown();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TorrServer send stoping...')));
                  },
                  icon: const Icon(Icons.stop, size: 24),
                  label: Text(l10n.stopTorrServerButton, style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              Center(
                child: ref
                    .watch(appVersionProvider)
                    .when(
                      data: (version) => Text(
                        'TorrsTV $version',
                        style: TextStyle(color: colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                      loading: () => Text(l10n.torrstvLoading),
                      error: (error, stack) => Text(l10n.torrstvError(error.toString())),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
