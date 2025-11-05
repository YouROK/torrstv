import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/ui/torrents_page/torrent_card.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/torrent_info.dart';
import 'package:torrstv/ui/torrents_page/torrents_provider.dart';

class TorrentPage extends ConsumerWidget {
  const TorrentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final listTorrentAsyncValue = ref.watch(listTorrentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Torrents'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: listTorrentAsyncValue.when(
              loading: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text('Loading...', style: TextStyle(color: colorScheme.secondary)),
                ],
              ),

              error: (err, stack) => Center(
                child: Text(
                  'Error: ${err.toString()}',
                  style: TextStyle(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),

              data: (torrents) {
                if (torrents.isEmpty) {
                  return Text('Empty list', style: TextStyle(color: colorScheme.onSurface));
                }

                return ListView.builder(
                  itemCount: torrents.length,
                  itemBuilder: (context, index) {
                    final torrent = torrents[index];

                    return TorrentCard(
                      torrent: torrent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TorrentInfoPage(hash: torrent["hash"])));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
