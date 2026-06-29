import 'package:flutter/material.dart';

import '../data/local/hive_service.dart';

/// Manages the app language (English / Kiswahili) with instant switching and
/// Hive persistence. Default language is Kiswahili.
class LanguageProvider extends ChangeNotifier {
  static const String _key = 'languageCode';

  /// Supported locales — Kiswahili first (default).
  static const List<Locale> supportedLocales = [
    Locale('sw'),
    Locale('en'),
  ];

  static const Locale _defaultLocale = Locale('sw');

  Locale _locale = _defaultLocale;

  Locale get locale => _locale;
  bool get isSwahili => _locale.languageCode == 'sw';
  bool get isEnglish => _locale.languageCode == 'en';

  /// Loads the saved language from Hive, falling back to Kiswahili.
  void init() {
    final saved = HiveService.appSettings.get(_key) as String?;
    if (saved == 'en' || saved == 'sw') {
      _locale = Locale(saved!);
    } else {
      _locale = _defaultLocale;
    }
  }

  /// Switches language instantly (no restart) and persists to Hive.
  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale) || locale.languageCode == _locale.languageCode) {
      return;
    }
    _locale = locale;
    notifyListeners();
    await HiveService.appSettings.put(_key, locale.languageCode);
  }

  Future<void> setLanguageCode(String code) => setLocale(Locale(code));

  bool _isSupported(Locale locale) =>
      supportedLocales.any((l) => l.languageCode == locale.languageCode);
}
