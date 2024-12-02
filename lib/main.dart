import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/services/music_service.dart';
import 'package:music_player/services/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => AudioDataProvider(audioDataService: AudioDataServiceImpl())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final colorScheme =
            getAppColorScheme(lightColorScheme, darkColorScheme);

        return MaterialApp.router(
          themeMode: themeMode,
          darkTheme: getAppTheme(colorScheme),
          theme: getAppTheme(colorScheme),
          debugShowCheckedModeBanner: false,
          // localizationsDelegates: const [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: appSupportedLocales,
          // locale: languageSetting,
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

    // Check permissions
    var storageStatus = await Permission.storage.status;
    var audioStatus = await Permission.audio.status;
    var mediaStatus = await Permission.mediaLibrary.status;

    await Future.wait([
      if (!storageStatus.isGranted) Permission.storage.request(),
      if (!audioStatus.isGranted) Permission.audio.request(),
      if (!mediaStatus.isGranted) Permission.mediaLibrary.request(),
    ]);

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
