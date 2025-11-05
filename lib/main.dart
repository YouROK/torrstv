import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/tmdb/tmdb.dart';
import 'package:torrstv/data/theme/theme.dart';
import 'package:torrstv/ui/main_navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Tmdb.init();

  runApp(ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)], child: MyApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => const MainNavigation())],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('404 - Страница не найдена: ${state.uri}'))),
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(title: 'TorrsTV', theme: AppThemes.darkTheme, routerConfig: goRouter);
  }
}
