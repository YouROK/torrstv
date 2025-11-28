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

    if (savedCode != null && isLanguageSupported(savedCode)) {
      return Locale(savedCode);
    }

    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (isLanguageSupported(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }

    return fallbackLocale;
  }

  Future<void> setLocale(String languageCode) async {
    if (!isLanguageSupported(languageCode)) {
      throw ArgumentError('Language $languageCode is not supported');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
    state = AsyncData(Locale(languageCode));
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(() => LocaleNotifier());
