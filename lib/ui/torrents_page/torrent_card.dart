import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/utils/bytes.dart';
import 'package:torrstv/l10n/app_localizations.dart';

class TorrentCard extends ConsumerWidget {
  final dynamic torrent;
  final VoidCallback? onTap;

  const TorrentCard({super.key, required this.torrent, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(minHeight: 84),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPoster(),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              torrent['title'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'sans-serif-condensed', height: 1.2),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: _buildHashInfo(colorScheme, l10n)),
                                Expanded(flex: 1, child: _buildSizeDateInfo(colorScheme)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.delete),
            color: colorScheme.error,
            onPressed: () {
              ref.read(torrServerApiProvider).remTorrent(torrent['hash']);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoster() {
    final posterUrl = torrent['poster'];
    if (posterUrl == null || posterUrl!.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: 60,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          posterUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHashInfo(ColorScheme colorScheme, AppLocalizations l10n) {
    final hash = torrent['hash'];
    final stat = torrent['stat'];
    String statStr = "";

    if (stat != null) {
      switch (stat) {
        case 0:
          statStr = l10n.torrentStatusAdded;
          break;
        case 1:
          statStr = l10n.torrentStatusGettingInfo;
          break;
        case 2:
          statStr = l10n.torrentStatusPreload;
          break;
        case 3:
          statStr = l10n.torrentStatusWorking;
          break;
        case 4:
          statStr = l10n.torrentStatusClosed;
          break;
        case 5:
          statStr = l10n.torrentStatusInDb;
          break;
        default:
          statStr = "";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hash != null && hash!.isNotEmpty)
          Text(
            hash!.toUpperCase(),
            style: TextStyle(fontFamily: 'sans-serif-condensed', color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 6),
        Text(
          statStr,
          style: TextStyle(fontFamily: 'sans-serif-condensed', color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSizeDateInfo(ColorScheme colorScheme) {
    final size = torrent['torrent_size'];
    final timestamp = torrent['timestamp'];
    String date = "";

    if (timestamp != null && timestamp! > 0) {
      DateTime d = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
      date = DateFormat('dd.MM.yyyy').format(d);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (size != null && size! > 0)
          Text(
            bytesFmt(size!),
            style: TextStyle(fontFamily: 'sans-serif-condensed', color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.w500),
          ),

        if (timestamp != null && timestamp! > 0)
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              date,
              style: TextStyle(fontFamily: 'sans-serif-condensed', color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
            ),
          ),
      ],
    );
  }
}
