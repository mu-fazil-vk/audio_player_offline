import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/services/audio_data_service.dart';
import 'package:music_player/services/offline_audio_service.dart';
import 'package:music_player/services/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  // Initialize the singleton audio service
  await OfflineAudioService.instance.initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AudioDataProvider(
          audioDataService: AudioDataServiceImpl(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => AudioProvider(
          OfflineAudioService.instance.audioHandler,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
      ),
      ChangeNotifierProxyProvider<AppSettingsProvider, ThemeProvider>(
        create: (context) => ThemeProvider(
          initialThemeMode: ThemeMode.system,
          appSettings: context.read<AppSettingsProvider>(),
        ),
        update: (context, appSettings, previousThemeProvider) => ThemeProvider(
          initialThemeMode: getThemeMode(appSettings.themeMode),
          appSettings: appSettings,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Future<void> updateAppState(
    BuildContext context, {
    ThemeMode? newThemeMode,
    Locale? newLocale,
    Color? newAccentColor,
    bool? useSystemColor,
  }) async {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.updateTheme(
      newThemeMode: newThemeMode,
      newLocale: newLocale,
      newAccentColor: newAccentColor,
      systemColorStatus: useSystemColor,
    );
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AudioProvider>().initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final themeProvider = context.watch<ThemeProvider>();
        final appSettingsProvider = context.watch<AppSettingsProvider>();

        final colorScheme = getAppColorScheme(
          lightColorScheme,
          darkColorScheme,
          themeProvider.brightness,
          appSettingsProvider,
        );

        return MaterialApp.router(
          darkTheme: ThemeData(
            primaryColor: appSettingsProvider.primaryColor,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: appSettingsProvider.primaryColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primaryColor: appSettingsProvider.primaryColor,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: appSettingsProvider.primaryColor,
              brightness: Brightness.light,
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: NavigationService.router,
        );
      },
    );
  }
}

Future<void> init() async {
  try {
    await Hive.initFlutter();

    final boxNames = ['settings', 'user'];

    for (final boxName in boxNames) {
      await Hive.openBox(boxName);
    }

    try {
      // Check and request permissions for Android 13
      if (await Permission.audio.isDenied ||
          await Permission.audio.isPermanentlyDenied) {
        await Permission.audio.request();
      }

      if (await Permission.mediaLibrary.isDenied ||
          await Permission.mediaLibrary.isPermanentlyDenied) {
        await Permission.mediaLibrary.request();
      }

      if (await Permission.storage.isDenied ||
          await Permission.storage.isPermanentlyDenied) {
        await Permission.storage.request();
      }

      // Your initialization code
    } catch (e) {
      print('Initialization Error: $e');
    }

    // audioHandler = await AudioService.init(
    //   builder: MusifyAudioHandler.new,
    //   config: const AudioServiceConfig(
    //     androidNotificationChannelId: 'com.gokadzev.musify',
    //     androidNotificationChannelName: 'Musify',
    //     androidNotificationIcon: 'drawable/ic_launcher_foreground',
    //     androidShowNotificationBadge: true,
    //   ),
    // );

    // Init router
    NavigationService.instance;
  } catch (e, stackTrace) {
    log('Initialization Error$e$stackTrace');
  }
}
