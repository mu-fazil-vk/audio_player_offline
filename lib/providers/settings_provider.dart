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
  late bool _crossFadeEnabled;
  late double _crossFadeDuration;
  late bool _equalizer;
  late Map<String, double> _equalizerPreset;

  // Theme Settings
  late bool _useSystemColor;
  late bool _usePureBlackColor;
  late String _themeMode;
  late Color _primaryColor;

  // UI Settings
  late bool _predictiveBack;
  late String _language;
  late bool _showLyrics;
  late bool _showAlbumArt;

  // Playback Settings
  late bool _shuffle;
  late bool _repeat;
  late String _defaultPlaybackQuality;

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
    _visualizerStyle = _box.get('visualizerStyle', defaultValue: 'Music 1');
    _crossFadeEnabled = _box.get('crossFadeEnabled', defaultValue: false);
    _crossFadeDuration = _box.get('crossFadeDuration', defaultValue: 2.0);
    _equalizer = _box.get('equalizer', defaultValue: false);
    _equalizerPreset = Map<String, double>.from(
        _box.get('equalizerPreset', defaultValue: _defaultEqualizerPreset));

    _useSystemColor = _box.get('useSystemColor', defaultValue: true);
    _usePureBlackColor = _box.get('usePureBlackColor', defaultValue: false);
    _themeMode = _box.get('themeMode', defaultValue: 'system');
    _primaryColor = Color(_box.get('primaryColor', defaultValue: 0xff91cef4));

    _predictiveBack = _box.get('predictiveBack', defaultValue: false);
    _language = _box.get('language', defaultValue: 'en');
    _showLyrics = _box.get('showLyrics', defaultValue: true);
    _showAlbumArt = _box.get('showAlbumArt', defaultValue: true);

    _shuffle = _box.get('shuffle', defaultValue: false);
    _repeat = _box.get('repeat', defaultValue: false);
    _defaultPlaybackQuality =
        _box.get('defaultPlaybackQuality', defaultValue: 'high');
  }

  // Getters
  bool get showAudioVisualizer => _showAudioVisualizer;
  String get visualizerStyle => _visualizerStyle;
  bool get crossFadeEnabled => _crossFadeEnabled;
  double get crossFadeDuration => _crossFadeDuration;
  bool get equalizer => _equalizer;
  Map<String, double> get equalizerPreset => _equalizerPreset;
  bool get useSystemColor => _useSystemColor;
  bool get usePureBlackColor => _usePureBlackColor;
  String get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  bool get predictiveBack => _predictiveBack;
  String get language => _language;
  bool get showLyrics => _showLyrics;
  bool get showAlbumArt => _showAlbumArt;
  bool get shuffle => _shuffle;
  bool get repeat => _repeat;
  String get defaultPlaybackQuality => _defaultPlaybackQuality;

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

  Future<void> setCrossFadeEnabled(bool value) async {
    _crossFadeEnabled = value;
    await _box.put('crossFadeEnabled', value);
    notifyListeners();
  }

  Future<void> setCrossFadeDuration(double value) async {
    _crossFadeDuration = value;
    await _box.put('crossFadeDuration', value);
    notifyListeners();
  }

  Future<void> setEqualizer(bool value) async {
    _equalizer = value;
    await _box.put('equalizer', value);
    notifyListeners();
  }

  Future<void> setEqualizerPreset(Map<String, double> value) async {
    _equalizerPreset = value;
    await _box.put('equalizerPreset', value);
    notifyListeners();
  }

  Future<void> setUseSystemColor(bool value) async {
    _useSystemColor = value;
    await _box.put('useSystemColor', value);
    notifyListeners();
  }

  Future<void> setUsePureBlackColor(bool value) async {
    _usePureBlackColor = value;
    await _box.put('usePureBlackColor', value);
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

  Future<void> setPredictiveBack(bool value) async {
    _predictiveBack = value;
    await _box.put('predictiveBack', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _box.put('language', value);
    notifyListeners();
  }

  Future<void> setShowLyrics(bool value) async {
    _showLyrics = value;
    await _box.put('showLyrics', value);
    notifyListeners();
  }

  Future<void> setShowAlbumArt(bool value) async {
    _showAlbumArt = value;
    await _box.put('showAlbumArt', value);
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

  Future<void> setDefaultPlaybackQuality(String value) async {
    _defaultPlaybackQuality = value;
    await _box.put('defaultPlaybackQuality', value);
    notifyListeners();
  }

  // Default equalizer preset
  static final Map<String, double> _defaultEqualizerPreset = {
    '32Hz': 0.0,
    '64Hz': 0.0,
    '125Hz': 0.0,
    '250Hz': 0.0,
    '500Hz': 0.0,
    '1kHz': 0.0,
    '2kHz': 0.0,
    '4kHz': 0.0,
    '8kHz': 0.0,
    '16kHz': 0.0,
  };

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
