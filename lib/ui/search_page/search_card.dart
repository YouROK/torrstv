import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:torrstv/core/utils/bytes.dart';

class SearchCard extends ConsumerWidget {
  final dynamic torrent;
  final VoidCallback? onTap;

  const SearchCard({super.key, required this.torrent, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final String title = torrent['title'] as String? ?? 'Название не указано';
    final String trackerName = torrent['trackerName'] as String? ?? 'N/A';
    final String magnet = torrent['magnet'] as String? ?? '';
    final int sid = torrent['sid'] as int? ?? 0;
    final int pir = torrent['pir'] as int? ?? 0;
    final int size = torrent['size'] as int? ?? 0;
    final String createTime = torrent['createTime'] as String? ?? '';

    String hash = '';
    if (magnet.isNotEmpty) {
      final uri = Uri.parse(magnet);
      final xtParam = uri.queryParameters['xt'];

      if (xtParam != null && xtParam.startsWith('urn:btih:')) {
        hash = xtParam.substring('urn:btih:'.length).toUpperCase();
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    _buildInfo(trackerName, hash, sid, pir),
                  ],
                ),
              ),

              const SizedBox(width: 16),
              _buildSizeDateInfo(colorScheme, size, createTime),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String trackerName, String hash, int sid, int pir) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(trackerName, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis, maxLines: 1),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.upload, size: 16, color: Colors.green),
              const SizedBox(width: 2),
              Text('$sid', style: const TextStyle(fontSize: 14, color: Colors.green)),

              const SizedBox(width: 10),

              const Icon(Icons.download, size: 16, color: Colors.red),
              const SizedBox(width: 2),
              Text('$pir', style: const TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 3,
          child: Text(
            hash,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'monospace'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeDateInfo(ColorScheme colorScheme, int size, String createTime) {
    String date = 'N/A';
    try {
      if (createTime.isNotEmpty) {
        DateTime dateTime = DateTime.parse(createTime);
        date = DateFormat('dd.MM.yyyy').format(dateTime);
      }
    } catch (e) {
      // Игнорируем ошибку парсинга даты, если формат неверен
      print('Date parsing error: $e');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Размер
        Text(
          bytesFmt(size),
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 16),
        ),

        const SizedBox(height: 4),

        // Дата
        Text(date, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }
}
