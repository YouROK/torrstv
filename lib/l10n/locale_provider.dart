import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> supportedLanguages = ['en', 'ru'];

Locale get fallbackLocale => Locale(supportedLanguages.first);

bool isLanguageSupported(String languageCode) {
  return supportedLanguages.contains(languageCode);
}

class LocaleNotifier extends AsyncNotifier<Locale> {
  static const _key = 'user_locale';

  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_key);

    if (savedCode != null && savedCode.isNotEmpty && isLanguageSupported(savedCode)) {
      return Locale(savedCode);
    }

    return _getSystemLocale();
  }

  Future<Locale> _getSystemLocale() async {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (isLanguageSupported(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }
    return fallbackLocale;
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);

    if (languageCode.isEmpty || languageCode == 'system') {
      state = AsyncData(await _getSystemLocale());
    } else if (isLanguageSupported(languageCode)) {
      state = AsyncData(Locale(languageCode));
    } else {
      state = AsyncData(await _getSystemLocale());
    }
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(() => LocaleNotifier());
