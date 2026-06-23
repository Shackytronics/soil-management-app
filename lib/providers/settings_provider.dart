import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keyTheme = 'theme_mode';
  static const _keyAutoSync = 'auto_sync';
  static const _keySyncWifiOnly = 'sync_wifi_only';
  static const _keyExportFormat = 'export_format';
  static const _keyExportNotes = 'export_notes';

  ThemeMode _themeMode = ThemeMode.system;
  bool _autoSync = true;
  bool _syncOnWifiOnly = false;
  String _defaultExportFormat = 'pdf';
  bool _exportIncludesNotes = true;

  ThemeMode get themeMode => _themeMode;
  bool get autoSync => _autoSync;
  bool get syncOnWifiOnly => _syncOnWifiOnly;
  String get defaultExportFormat => _defaultExportFormat;
  bool get exportIncludesNotes => _exportIncludesNotes;

  String get themeModeLabel => switch (_themeMode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System',
      };

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _parseTheme(prefs.getString(_keyTheme));
    _autoSync = prefs.getBool(_keyAutoSync) ?? true;
    _syncOnWifiOnly = prefs.getBool(_keySyncWifiOnly) ?? false;
    _defaultExportFormat = prefs.getString(_keyExportFormat) ?? 'pdf';
    _exportIncludesNotes = prefs.getBool(_keyExportNotes) ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode.name);
  }

  Future<void> setAutoSync(bool value) async {
    _autoSync = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoSync, value);
  }

  Future<void> setSyncOnWifiOnly(bool value) async {
    _syncOnWifiOnly = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySyncWifiOnly, value);
  }

  Future<void> setDefaultExportFormat(String format) async {
    _defaultExportFormat = format;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyExportFormat, format);
  }

  Future<void> setExportIncludesNotes(bool value) async {
    _exportIncludesNotes = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyExportNotes, value);
  }

  ThemeMode _parseTheme(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
