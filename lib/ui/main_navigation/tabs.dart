import 'package:flutter/material.dart';
import 'package:torrstv/ui/add_page/add_page.dart';
import 'package:torrstv/ui/donate_page/donate_page.dart';
import 'package:torrstv/ui/search_page/search_page.dart';
import 'package:torrstv/ui/settings_page/settings_page.dart';
import 'package:torrstv/ui/torrents_page/torrents_page.dart';
import 'package:torrstv/ui/torrserver_page/torrserver_page.dart';

class TabItem {
  final String label;
  final Widget page;

  const TabItem({required this.label, required this.page});
}

class TabsConfiguration {
  static List<TabItem> items = [
    TabItem(label: 'Torrents', page: TorrentPage()),
    TabItem(label: 'Add', page: AddPage()),
    TabItem(label: 'Search', page: SearchPage()),
    TabItem(label: 'Donate', page: DonatePage()),
    TabItem(label: 'TorrServer', page: TorrServerPage()),
    TabItem(label: 'Settings', page: SettingsPage()),
  ];

  static List<Tab> get tabWidgets => items.map((item) => Tab(text: item.label, height: 50)).toList();

  static List<Widget> get pageWidgets => items.map((item) => item.page).toList();

  static int get length => items.length;
}
