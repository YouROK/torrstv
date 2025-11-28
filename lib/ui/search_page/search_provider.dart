import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:torrstv/core/utils/http.dart';

class SearchUIState {
  final bool isLoading;
  final String searchQuery;
  final List<dynamic> allTorrents;
  final List<dynamic> filteredTorrents;
  final String sortField;
  final bool sortOrderAscending;
  final String filterQuality;
  final String filterVoice;
  final String filterSeason;
  final String filterTracker;
  final String error;

  SearchUIState({
    this.isLoading = false,
    this.searchQuery = '',
    this.allTorrents = const [],
    this.filteredTorrents = const [],
    this.sortField = 'size',
    this.sortOrderAscending = true,
    this.filterQuality = "All",
    this.filterVoice = "All",
    this.filterSeason = "All",
    this.filterTracker = "All",
    this.error = '',
  });

  SearchUIState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<dynamic>? allTorrents,
    List<dynamic>? filteredTorrents,
    String? sortField,
    bool? sortOrderAscending,
    String? filterQuality,
    String? filterVoice,
    String? filterSeason,
    String? filterTracker,
    String? error,
  }) {
    return SearchUIState(
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      allTorrents: allTorrents ?? this.allTorrents,
      filteredTorrents: filteredTorrents ?? this.filteredTorrents,
      sortField: sortField ?? this.sortField,
      sortOrderAscending: sortOrderAscending ?? this.sortOrderAscending,
      filterQuality: filterQuality ?? this.filterQuality,
      filterVoice: filterVoice ?? this.filterVoice,
      filterSeason: filterSeason ?? this.filterSeason,
      filterTracker: filterTracker ?? this.filterTracker,
      error: error ?? this.error,
    );
  }
}

class SearchUINotifier extends StateNotifier<SearchUIState> {
  final Ref _ref;

  SearchUINotifier(this._ref) : super(SearchUIState());

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query, allTorrents: [], filteredTorrents: [], error: '');
    try {
      var link = "http://torrs.ru/search?query=$query";
      final resp = await httpGet(link, '');
      final List<dynamic> torrentList = json.decode(resp.data ?? '[]');
      state = state.copyWith(allTorrents: torrentList, isLoading: false);
      _updateFiltersAndSort();
      _updateDropdownOptions(state.filteredTorrents);
      if (!resp.isSuccess) {
        state = state.copyWith(error: resp.error ?? '');
      }
    } catch (e) {
      print(e);
      state = state.copyWith(isLoading: false, allTorrents: [], filteredTorrents: [], error: e.toString());
    }
  }

  void _updateFiltersAndSort() {
    List<dynamic> currentList = List.from(state.allTorrents);

    final quality = state.filterQuality;
    final voice = state.filterVoice;
    final season = state.filterSeason;
    final tracker = state.filterTracker;

    if (quality != "All") {
      int q = int.tryParse(quality) ?? 0;
      currentList.removeWhere((element) => element['quality'] != q);
    }

    if (voice != "All") {
      currentList.removeWhere((element) => (element['voices'] is! List) || !List<String>.from(element['voices']).contains(voice));
    }

    if (season != "All") {
      int s = int.tryParse(season) ?? 0;
      currentList.removeWhere((element) => (element['seasons'] is! List) || !List<dynamic>.from(element['seasons']).contains(s));
    }

    if (tracker != "All") {
      currentList.removeWhere((element) => element['trackerName'] != tracker);
    }

    if (state.sortField == 'peers') {
      currentList.sort((a, b) => b['sid'].compareTo(a['sid']));
    } else if (state.sortField == 'size') {
      currentList.sort((a, b) => b['size'].compareTo(a['size']));
    } else if (state.sortField == 'date') {
      currentList.sort((a, b) {
        final dateA = DateTime.tryParse(a['createTime'] ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['createTime'] ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });
    }

    if (!state.sortOrderAscending) {
      currentList = currentList.reversed.toList();
    }

    state = state.copyWith(filteredTorrents: currentList);
  }

  void _updateDropdownOptions(List<dynamic> torrents) {
    // 1. Quality
    Set<String> valuesQ = <String>{};
    for (var e in torrents) {
      if (e['quality'] != null) {
        valuesQ.add(e['quality'].toString());
      }
    }
    var sortedQuality = valuesQ.toList();
    sortedQuality.sort((a, b) => int.tryParse(b)!.compareTo(int.tryParse(a)!));
    sortedQuality.insert(0, "All");

    _ref.read(qualityOptionsProvider.notifier).state = sortedQuality;

    // 2. Voice
    Set<String> valuesV = <String>{};
    for (var e in torrents) {
      if (e['voices'] is List) {
        valuesV.addAll(List<String>.from(e['voices']));
      }
    }
    var sortedVoice = valuesV.toList();
    sortedVoice.sort((a, b) => a.compareTo(b));
    sortedVoice.insert(0, "All");
    _ref.read(voiceOptionsProvider.notifier).state = sortedVoice;

    // 3. Seasons
    Set<String> valuesS = <String>{};
    for (var e in torrents) {
      if (e['seasons'] is List) {
        valuesS.addAll(List<dynamic>.from(e['seasons']).map((s) => "$s").toList());
      }
    }
    var sortedSeasons = valuesS.toList();
    sortedSeasons.sort((a, b) => a.compareTo(b));
    sortedSeasons.insert(0, "All");
    _ref.read(seasonOptionsProvider.notifier).state = sortedSeasons;

    // 4. Tracker
    Set<String> valuesT = <String>{};
    for (var e in torrents) {
      if (e['trackerName'] != null) {
        valuesT.add(e['trackerName']);
      }
    }
    var sortedTracker = valuesT.toList();
    sortedTracker.sort((a, b) => a.compareTo(b));
    sortedTracker.insert(0, "All");
    _ref.read(trackerOptionsProvider.notifier).state = sortedTracker;
  }

  void setSortField(String field) {
    state = state.copyWith(sortField: field);
    _updateFiltersAndSort();
  }

  void toggleSortOrder() {
    final ascending = !state.sortOrderAscending;
    state = state.copyWith(sortOrderAscending: ascending);
    _updateFiltersAndSort();
  }

  void setQuality(String value) {
    state = state.copyWith(filterQuality: value);
    _updateFiltersAndSort();
  }

  void setVoice(String value) {
    state = state.copyWith(filterVoice: value);
    _updateFiltersAndSort();
  }

  void setSeason(String value) {
    state = state.copyWith(filterSeason: value);
    _updateFiltersAndSort();
  }

  void setTracker(String value) {
    state = state.copyWith(filterTracker: value);
    _updateFiltersAndSort();
  }
}

final qualityOptionsProvider = StateProvider<List<String>>((ref) => ['All']);
final voiceOptionsProvider = StateProvider<List<String>>((ref) => ['All']);
final seasonOptionsProvider = StateProvider<List<String>>((ref) => ['All']);
final trackerOptionsProvider = StateProvider<List<String>>((ref) => ['All']);

final torrsSearchProvider = StateNotifierProvider<SearchUINotifier, SearchUIState>((ref) {
  return SearchUINotifier(ref);
});
