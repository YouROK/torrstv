import 'package:flutter/material.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/ui/add_page/add_page.dart';
import 'package:torrstv/ui/donate_page/donate_page.dart';
import 'package:torrstv/ui/search_page/search_page.dart';
import 'package:torrstv/ui/settings_page/settings_page.dart';
import 'package:torrstv/ui/torrents_page/torrents_page.dart';
import 'package:torrstv/ui/torrserver_page/torrserver_page.dart';

class TabItemDef {
  final String Function(BuildContext context) labelBuilder;
  final Widget Function(BuildContext context) pageBuilder;

  const TabItemDef({required this.labelBuilder, required this.pageBuilder});
}

final List<TabItemDef> tabDefinitions = [
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.torrents, pageBuilder: (context) => const TorrentPage()),
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.add, pageBuilder: (context) => const AddPage()),
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.search, pageBuilder: (context) => const SearchPage()),
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.donate, pageBuilder: (context) => const DonatePage()),
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.torrServer, pageBuilder: (context) => const TorrServerPage()),
  TabItemDef(labelBuilder: (context) => AppLocalizations.of(context)!.settings, pageBuilder: (context) => const SettingsPage()),
];
