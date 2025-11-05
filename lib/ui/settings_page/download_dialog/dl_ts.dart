import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dl_ts_provider.dart';

void startDownloadDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), child: const _DownloadProgressDialog());
    },
  );
  ref.read(downloadStateProvider.notifier).startDownload();
}

class _DownloadProgressDialog extends ConsumerWidget {
  const _DownloadProgressDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(downloadStateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !downloadState.isDownloading,
      child: AlertDialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        title: Text(
          'Download TorrServer',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: downloadState.progress, backgroundColor: colorScheme.onSurface.withOpacity(0.1), color: colorScheme.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 15),

            SelectableText(
              downloadState.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.9), fontSize: 14),
            ),
          ],
        ),

        actions: [
          if (downloadState.isDownloading)
            TextButton(
              onPressed: () {
                ref.read(downloadStateProvider.notifier).cancelDownload();
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Закрыть',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
