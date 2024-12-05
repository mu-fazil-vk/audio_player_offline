// settings_service.dart is a file that contains all the settings and preferences of the app. It uses Hive to store the settings locally on the device. It also contains some non-storage notifiers that are used to control the shuffle and repeat functionality of the app.
// Preferences

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



final useSystemColor = ValueNotifier<bool>(
  Hive.box('settings').get('useSystemColor', defaultValue: true),
);

final usePureBlackColor = ValueNotifier<bool>(
  Hive.box('settings').get('usePureBlackColor', defaultValue: false),
);

final predictiveBack = ValueNotifier<bool>(
  Hive.box('settings').get('predictiveBack', defaultValue: false),
);

// Locale languageSetting = Locale(
//   appLanguages[Hive.box('settings').get('language', defaultValue: 'English')
//           as String] ??
//       'en',
// );

final themeModeSetting =
    Hive.box('settings').get('themeMode', defaultValue: 'dark') as String;

Color primaryColorSetting =
    Color(Hive.box('settings').get('accentColor', defaultValue: 0xff91cef4));

// Non-Storage Notifiers

final shuffleNotifier = ValueNotifier<bool>(false);
final repeatNotifier = ValueNotifier<bool>(false);
