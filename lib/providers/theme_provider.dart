import 'package:flutter/material.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/providers/settings_provider.dart';

class ThemeProvider extends ChangeNotifier {
  final AppSettingsProvider _appSettings;
  ThemeMode _themeMode;
  Brightness _brightness;
  
  ThemeProvider({
    required ThemeMode initialThemeMode,
    required AppSettingsProvider appSettings,
  }) : _themeMode = initialThemeMode,
       _appSettings = appSettings,
       _brightness = getBrightnessFromThemeMode(initialThemeMode);

  ThemeMode get themeMode => _themeMode;
  Brightness get brightness => _brightness;

  void setThemeMode(String mode) {
    final newThemeMode = [
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark
    ].firstWhere(
      (element) => element.name == mode,
      orElse: () => ThemeMode.system
    );
    updateTheme(newThemeMode: newThemeMode);
  }

  void updateTheme({
    ThemeMode? newThemeMode,
    Locale? newLocale,
    Color? newAccentColor,
    bool? systemColorStatus,
  }) {
    if (newThemeMode != null) {
      _themeMode = newThemeMode;
      _brightness = getBrightnessFromThemeMode(newThemeMode);
      notifyListeners();
    }
    
    if (newAccentColor != null) {
      if (systemColorStatus != null && 
          _appSettings.useSystemColor != systemColorStatus) {
        _appSettings.setUseSystemColor(systemColorStatus);
      }
      _appSettings.setPrimaryColor(newAccentColor);
    }
  }

  static Brightness getBrightnessFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      default:
        return WidgetsBinding.instance.window.platformBrightness;
    }
  }
}