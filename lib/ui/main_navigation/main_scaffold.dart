import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/ts.dart';
import 'package:torrstv/ui/main_navigation/tab_controller_provider.dart';
import 'package:torrstv/ui/main_navigation/tabs.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = TabsConfiguration.tabWidgets;
  final List<Widget> _pages = TabsConfiguration.pageWidgets;
  final int _length = TabsConfiguration.length;

  @override
  void initState() {
    super.initState();
    final tss = ref.read(torrServerServiceProvider);
    tss.startTorrServer().then((value) {
      if (value.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
      }
    });

    _tabController = TabController(length: _length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ProviderScope(
      overrides: [tabControllerProvider.overrideWithValue(_tabController)],
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 100,
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      padding: EdgeInsets.all(10),
                      indicatorColor: colorScheme.primary,
                      dividerColor: colorScheme.primary,
                      dividerHeight: 0.3,
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(25), color: colorScheme.surface),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: colorScheme.primary,
                      // overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      //   if (states.contains(WidgetState.focused) || states.contains(WidgetState.hovered)) {
                      //     return Colors.transparent;
                      //   }
                      //   return null;
                      // }),
                      unselectedLabelColor: colorScheme.onSurface.withAlpha(156),
                      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      tabs: _tabs,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: _pages),
            ),
          ],
        ),
      ),
    );
  }
}
