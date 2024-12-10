import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:music_player/core/theme/dynamic_theme_fix.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:music_player/services/settings/settings_service.dart';

ThemeMode themeMode = getThemeMode(themeModeSetting);
Brightness brightness = getBrightnessFromThemeMode(themeMode);

PageTransitionsBuilder transitionsBuilder = predictiveBack.value
    ? const PredictiveBackPageTransitionsBuilder()
    : const CupertinoPageTransitionsBuilder();

Brightness getBrightnessFromThemeMode(
  ThemeMode themeMode,
) {
  final themeBrightnessMapping = {
    ThemeMode.light: Brightness.light,
    ThemeMode.dark: Brightness.dark,
    ThemeMode.system:
        SchedulerBinding.instance.platformDispatcher.platformBrightness,
  };

  return themeBrightnessMapping[themeMode] ?? Brightness.dark;
}

ThemeMode getThemeMode(String themeModeString) {
  switch (themeModeString) {
    case 'system':
      return ThemeMode.system;
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

ColorScheme getAppColorScheme(
  ColorScheme? lightColorScheme,
  ColorScheme? darkColorScheme,
  Brightness brightness,
  AppSettingsProvider settings,
) {
  // temp-fix: https://github.com/material-foundation/flutter-packages/issues/582
  if (
      lightColorScheme != null &&
      darkColorScheme != null) {
    (lightColorScheme, darkColorScheme) =
        generateDynamicColourSchemes(lightColorScheme, darkColorScheme);
  }

  
    return ColorScheme.fromSeed(
      seedColor: settings.primaryColor,
      brightness: brightness,
    ).harmonized();
}

ThemeData getAppTheme(ColorScheme colorScheme) {
  final base = colorScheme.brightness == Brightness.light
      ? ThemeData.light()
      : ThemeData.dark();

  final isPureBlackUsable =
      colorScheme.brightness == Brightness.dark && usePureBlackColor.value;

  final bgColor = colorScheme.brightness == Brightness.light
      ? colorScheme.surfaceContainer
      : (isPureBlackUsable ? const Color(0xFF000000) : null);

  return ThemeData(
    scaffoldBackgroundColor: bgColor,
    colorScheme: colorScheme,
    cardColor: bgColor,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: bgColor,
      iconTheme: IconThemeData(color: colorScheme.primary),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontFamily: 'paytoneOne',
        fontWeight: FontWeight.w300,
        color: colorScheme.primary,
      ),
      elevation: 0,
    ),
    listTileTheme: base.listTileTheme.copyWith(
      textColor: colorScheme.primary,
      iconColor: colorScheme.primary,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(backgroundColor: bgColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.fromLTRB(18, 14, 20, 14),
    ),
    navigationBarTheme:
        base.navigationBarTheme.copyWith(backgroundColor: bgColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: transitionsBuilder,
      },
    ),
  );
}
