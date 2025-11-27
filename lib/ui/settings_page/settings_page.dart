import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:torrstv/core/constants/app_info.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/services/torrserver/ts.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/utils/platform_utils.dart';
import 'package:torrstv/ui/settings_page/download_dialog/dl_ts.dart';

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
    final settingsNotifier = ref.read(settingsProvider);
    final hostController = ref.watch(_hostControllerProvider);
    final authController = ref.watch(_authControllerProvider);
    final playerController = ref.watch(_playerControllerProvider);
    final isOuterPlayerEnabled = ref.watch(_isOuterPlayerEnabledLocalProvider);
    final isSearchSaveEnabled = ref.watch(_isSearchSaveProvider);

    final isOuterPlayerEnabledNotifier = ref.read(_isOuterPlayerEnabledLocalProvider.notifier);
    final isSearchSaveEnabledNotifier = ref.read(_isSearchSaveProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;

    final showDownloadButton = isShowDownloadTS();

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
      appBar: AppBar(title: const Text('Settings'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              //Адрес ТС
              const SizedBox(height: 20),
              TextField(
                controller: hostController,
                keyboardType: TextInputType.url,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Address of TorrServer (http://<host>:<port>)',
                  hintText: 'http://127.0.0.1:8090',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.5),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ),

              //Аутентификация
              const SizedBox(height: 20),
              TextField(
                controller: authController,
                keyboardType: TextInputType.url,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Auth of TorrServer (username:password)',
                  hintText: 'username:password',
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
                    child: TextField(
                      controller: playerController,
                      keyboardType: TextInputType.url,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Select a player',
                        hintText: 'vlc, mpv, etc...',
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

              // Сохранять настройки
              const SizedBox(height: 40),
              SwitchListTile(
                title: const Text('Remember search parameters'),
                onChanged: (value) {
                  isSearchSaveEnabledNotifier.state = value;
                },
                value: isSearchSaveEnabled,
              ),

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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved!')));
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
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
                  label: const Text('Download TorrServer', style: TextStyle(fontSize: 16)),
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
                  label: const Text('Start TorrServer', style: TextStyle(fontSize: 16)),
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
                  label: const Text('Stop TorrServer', style: TextStyle(fontSize: 16)),
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
                      loading: () => const Text('TorrsTV Loading...'),
                      error: (error, stack) => Text('TorrsTV Error: $error'),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
