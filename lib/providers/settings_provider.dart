import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class AppSettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _userBoxName = 'user';
  late Box _box;
  Box? _userBox;

  // Audio Settings
  late bool _showAudioVisualizer;
  late String _visualizerStyle;

  // Theme Settings
  late String _themeMode;
  late Color _primaryColor;

  late String _language;

  // Playback Settings
  late bool _shuffle;
  late bool _repeat;

  AppSettingsProvider() {
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }

    // Load all settings with defaults

    _showAudioVisualizer = _box.get('showAudioVisualizer', defaultValue: true);
    _visualizerStyle = _box.get('visualizerStyle', defaultValue: 'Music2');

    _themeMode = _box.get('themeMode', defaultValue: 'system');
    _primaryColor = Color(_box.get('primaryColor', defaultValue: 0xff91cef4));

    _language = _box.get('language', defaultValue: 'en');

    _shuffle = _box.get('shuffle', defaultValue: false);
    _repeat = _box.get('repeat', defaultValue: false);
  }

  // Getters
  bool get showAudioVisualizer => _showAudioVisualizer;
  String get visualizerStyle => _visualizerStyle;
  String get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  String get language => _language;
  bool get shuffle => _shuffle;
  bool get repeat => _repeat;

  // Setters with persistence

  Future<void> setShowAudioVisualizer(bool value) async {
    _showAudioVisualizer = value;
    await _box.put('showAudioVisualizer', value);
    notifyListeners();
  }

  Future<void> setVisualizerStyle(String value) async {
    _visualizerStyle = value;
    await _box.put('visualizerStyle', value);
    notifyListeners();
  }

  Future<void> setThemeMode(String value) async {
    _themeMode = value;
    await _box.put('themeMode', value);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color value) async {
    _primaryColor = value;
    await _box.put('primaryColor', value.value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _box.put('language', value);
    notifyListeners();
  }

  Future<void> setShuffle(bool value) async {
    _shuffle = value;
    await _box.put('shuffle', value);
    notifyListeners();
  }

  Future<void> setRepeat(bool value) async {
    _repeat = value;
    await _box.put('repeat', value);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _box.clear();
    await _initializeSettings();
    if (Hive.isBoxOpen(_userBoxName)) {
      _userBox = Hive.box(_userBoxName);
      await _userBox!.clear();
    } else {
      await Hive.openBox(_userBoxName);
      _userBox = Hive.box(_userBoxName);
      await _userBox!.clear();
    }
    if (Hive.isBoxOpen('user')) {
      await Hive.openBox('user');
    }
    notifyListeners();
  }

  // Reset all settings to default
  Future<void> resetToDefaults() async {
    await _box.clear();
    await _initializeSettings();
    notifyListeners();
  }
}
