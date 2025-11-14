import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/ui/main_navigation/tab_controller_provider.dart';
import 'package:torrstv/ui/search_page/search_card.dart';
import 'package:torrstv/ui/search_page/search_provider.dart';

class SearchPage extends ConsumerWidget {
  SearchPage({super.key});

  final TextEditingController _textController = TextEditingController();

  final List<Widget> torrentsSort = <Widget>[const Text('By Peers'), const Text('By Size'), const Text('By Date')];
  final List<String> sortFields = ['peers', 'size', 'date'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final state = ref.watch(torrsSearchProvider);
    final notifier = ref.read(torrsSearchProvider.notifier);

    final qualityOptions = ref.watch(qualityOptionsProvider);
    final voiceOptions = ref.watch(voiceOptionsProvider);
    final seasonOptions = ref.watch(seasonOptionsProvider);
    final trackerOptions = ref.watch(trackerOptionsProvider);

    if (_textController.text.isEmpty) {
      _textController.text = state.searchQuery;
    }

    final int selectedSortIndex = sortFields.indexOf(state.sortField);
    final List<dynamic> torrentsToDisplay = state.filteredTorrents;

    // --- Статические виджеты (поиск, сортировка, фильтры) ---
    final List<Widget> staticHeaderWidgets = [
      const SizedBox(height: 5),
      // Поле ввода
      TextField(
        controller: _textController,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: 'Enter a name',
          hintText: 'Venom 2018, Terminator 2, etc...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.5),
          labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: SizedBox(height: 20, width: 20, child: state.isLoading ? const CircularProgressIndicator() : const Icon(Icons.search)),
              onPressed: () {
                if (!state.isLoading) {
                  notifier.search(_textController.text);
                }
              },
            ),
          ),
        ),
        onSubmitted: (String query) {
          notifier.search(query);
        },
      ),
      // Сортировка
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                notifier.setSortField(sortFields[index]);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.black,
              fillColor: Colors.blue[200],
              color: Colors.blue[400],
              constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
              isSelected: List.generate(sortFields.length, (i) => i == selectedSortIndex),
              children: torrentsSort,
            ),
            const SizedBox(width: 10),
            Tooltip(
              message: state.sortOrderAscending ? 'From largest to smallest' : 'From smallest to largest',
              child: ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  notifier.toggleSortOrder();
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                fillColor: Colors.transparent,
                color: Colors.blue[400],
                constraints: const BoxConstraints(minHeight: 40.0, minWidth: 40.0),
                isSelected: const [true],
                children: <Widget>[Icon(state.sortOrderAscending ? Icons.arrow_downward : Icons.arrow_upward)],
              ),
            ),
          ],
        ),
      ),

      // Фильтры
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            // 2. Фильтр "Качество"
            SizedBox(
              width: 150,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(filled: true, labelText: 'Quality'),
                initialValue: state.filterQuality,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  notifier.setQuality(value ?? "Все");
                },
                items: qualityOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),

            // 3. Фильтр "Озвучка"
            SizedBox(
              width: 240,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(filled: true, labelText: 'Voice'),
                initialValue: state.filterVoice,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  notifier.setVoice(value ?? "Все");
                },
                items: voiceOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),

            // 4. Фильтр "Сезоны"
            SizedBox(
              width: 150,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(filled: true, labelText: 'Seasons'),
                initialValue: state.filterSeason,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  notifier.setSeason(value ?? "Все");
                },
                items: seasonOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),

            // 5. Фильтр "Трекер"
            SizedBox(
              width: 150,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(filled: true, labelText: 'Tracker'),
                initialValue: state.filterTracker,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  notifier.setTracker(value ?? "Все");
                },
                items: trackerOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      const Divider(indent: 10, endIndent: 10),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: staticHeaderWidgets),
            ),

            if (state.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()),
                ),
              )
            else if (torrentsToDisplay.isEmpty && state.searchQuery.isNotEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(padding: EdgeInsets.all(30), child: Text('By query "${state.searchQuery}" not found.')),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Torrents: ${torrentsToDisplay.length}"), const SizedBox(height: 10)]),
              ),
              SliverList.builder(
                itemCount: torrentsToDisplay.length,
                itemBuilder: (context, index) {
                  final torrent = torrentsToDisplay[index];
                  return SearchCard(
                    torrent: torrent,
                    onTap: () async {
                      try {
                        final api = ref.read(torrServerApiProvider);
                        final success = await api.addTorrent(torrent['magnet'], torrent['title'], '', '');
                        if (success) {
                          final tabController = ref.read(tabControllerProvider);
                          tabController.animateTo(0);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding torrent'), backgroundColor: Colors.red));
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                      }
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
