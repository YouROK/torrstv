import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/ui/main_navigation/tab_controller_provider.dart';
import 'package:torrstv/ui/search_page/search_card.dart';
import 'package:torrstv/ui/search_page/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    final settings = ref.read(settingsProvider);
    final notifier = ref.read(torrsSearchProvider.notifier);

    // создаём контроллер сразу
    _textController = TextEditingController();

    // восстанавливаем параметры, только если разрешено
    if (settings.isSearchSave()) {
      final q = settings.getSearchQuery() ?? '';
      final field = settings.getSortField() ?? 'size';
      final asc = settings.getSortOrderAscending();

      _textController.text = q;

      // откладываем изменения провайдера на момент, когда дерево уже построено
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 1. сортировка
        notifier.setSortField(field);
        if (notifier.state.sortOrderAscending != asc) {
          notifier.toggleSortOrder();
        }
        // 2. поиск (если был сохранённый запрос)
        if (q.isNotEmpty) notifier.search(q);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveSearchParams() {
    final settings = ref.read(settingsProvider);
    settings.setSearchQuery(_textController.text.trim());
    settings.setSortField(ref.read(torrsSearchProvider).sortField);
    settings.setSortOrderAscending(ref.read(torrsSearchProvider).sortOrderAscending);
  }

  void _onSearch(String query) {
    ref.read(torrsSearchProvider.notifier).search(query);
    _saveSearchParams();
  }

  void _onSortChanged(String field) {
    ref.read(torrsSearchProvider.notifier).setSortField(field);
    _saveSearchParams();
  }

  void _onToggleOrder() {
    ref.read(torrsSearchProvider.notifier).toggleSortOrder();
    _saveSearchParams();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(torrsSearchProvider);

    if (_textController.text != state.searchQuery && _textController.text.isEmpty && state.searchQuery.isNotEmpty) {
      _textController.text = state.searchQuery;
    }

    final List<Widget> torrentsSort = <Widget>[const Text('By Peers'), const Text('By Size'), const Text('By Date')];
    final List<String> sortFields = ['peers', 'size', 'date'];
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
              onPressed: state.isLoading ? null : () => _onSearch(_textController.text.trim()),
              child: SizedBox(height: 20, width: 20, child: state.isLoading ? const CircularProgressIndicator() : const Icon(Icons.search)),
            ),
          ),
        ),
        onSubmitted: _onSearch,
      ),
      // Сортировка
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (i) => _onSortChanged(sortFields[i]),
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
                onPressed: (_) => _onToggleOrder(),
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
            _filterDrop('Quality', state.filterQuality, 150, ref.read(qualityOptionsProvider), (v) => ref.read(torrsSearchProvider.notifier).setQuality(v ?? 'All')),
            _filterDrop('Voice', state.filterVoice, 240, ref.read(voiceOptionsProvider), (v) => ref.read(torrsSearchProvider.notifier).setVoice(v ?? 'All')),
            _filterDrop('Seasons', state.filterSeason, 150, ref.read(seasonOptionsProvider), (v) => ref.read(torrsSearchProvider.notifier).setSeason(v ?? 'All')),
            _filterDrop('Tracker', state.filterTracker, 150, ref.read(trackerOptionsProvider), (v) => ref.read(torrsSearchProvider.notifier).setTracker(v ?? 'All')),
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

  Widget _filterDrop(String label, String value, double width, List<String> items, ValueChanged<String?> onChanged) => SizedBox(
    width: width,
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(filled: true, labelText: label),
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    ),
  );
}
