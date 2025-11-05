import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final showDownloadButton = isShowDownloadTS();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
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
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  settingsNotifier.setTSHost(hostController.text);
                  settingsNotifier.setTSAuth(authController.text); //TODO check is base64 need
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
