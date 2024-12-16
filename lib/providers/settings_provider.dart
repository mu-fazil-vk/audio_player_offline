import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:provider/provider.dart';

@HiveType(typeId: 1)
class AppSettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _userBoxName = 'user';
  late Box _box;
  Box? _userBox;

  // Audio Settings
  late bool _showAudioAnimation;
  late String _audioAnimationStyle;

  late bool _isClassicPlayer;

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

    _showAudioAnimation = _box.get('showAudioAnimation', defaultValue: true);
    _audioAnimationStyle = _box.get('audioAnimationStyle', defaultValue: 'Music2');

    _themeMode = _box.get('themeMode', defaultValue: 'system');
    _primaryColor = Color(_box.get('primaryColor', defaultValue: 0xff91cef4));

    _language = _box.get('language', defaultValue: 'en');

    _shuffle = _box.get('shuffle', defaultValue: false);
    _repeat = _box.get('repeat', defaultValue: false);
    _isClassicPlayer = _box.get('isClassicPlayer', defaultValue: false);
  }

  // Getters
  bool get showAudioAnimation => _showAudioAnimation;
  String get audioAnimationStyle => _audioAnimationStyle;
  String get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  String get language => _language;
  bool get shuffle => _shuffle;
  bool get repeat => _repeat;
  bool get isClassicPlayer => _isClassicPlayer;

  // Setters with persistence

  Future<void> setShowAudioVisualizer(bool value) async {
    _showAudioAnimation = value;
    await _box.put('showAudioAnimation', value);
    notifyListeners();
  }

  Future<void> setVisualizerStyle(String value) async {
    _audioAnimationStyle = value;
    await _box.put('audioAnimationStyle', value);
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

  Future<void> setIsClassicPlayer(bool value) async {
    _isClassicPlayer = value;
    await _box.put('isClassicPlayer', value);
    notifyListeners();
  }

  Future<void> clearAllData(BuildContext context) async {
    await _box.clear();
    await _initializeSettings();
    if (Hive.isBoxOpen(_userBoxName)) {
      _userBox = Hive.box(_userBoxName);
      await _userBox!.clear();
    } else {
      _userBox = await Hive.openBox(_userBoxName);
      await _userBox!.clear();
    }
    notifyListeners();
    if (context.mounted) {
      context.read<AudioDataProvider>().clearCaches();
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
