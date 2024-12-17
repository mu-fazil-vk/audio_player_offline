import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/main.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/widgets/common/custom_drop_down.dart';
import 'package:music_player/widgets/settings.dart/color_picker_tile.dart';
import 'package:provider/provider.dart';

final _themeModes = [
  DropdownMenuItem(
    value: "system",
    child: Text(LocaleKeys.theme_system.tr()),
  ),
  DropdownMenuItem(
    value: "light",
    child: Text(LocaleKeys.theme_light.tr()),
  ),
  DropdownMenuItem(
    value: "dark",
    child: Text(LocaleKeys.theme_dark.tr()),
  ),
];

class CommonSettingsSection extends StatelessWidget {
  const CommonSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<AppSettingsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.common.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.language.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(LocaleKeys.selectLanguage.tr()),
          leading: Icon(Icons.language,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          trailing: Text(
            context.locale.toLanguageTag().toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {
            context.goNamed('languages');
          },
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.theme_title.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          leading: Icon(Icons.dark_mode_rounded,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          trailing: CustomDropdown(
              items: _themeModes,
              hint: LocaleKeys.theme_dark.tr(),
              selectedItem: context.watch<AppSettingsProvider>().themeMode,
              onChanged: (value) async {
                if (value != null) {
                  settingsProvider.setThemeMode(value);
                  themeProvider.setThemeMode(value);
                  await MyApp.updateAppState(
                    context,
                    newThemeMode: [
                      ThemeMode.system,
                      ThemeMode.light,
                      ThemeMode.dark
                    ].firstWhere((element) => element.name == value,
                        orElse: () => ThemeMode.system),
                  );
                }
              }),
        ),
        20.ph,
        ColorPickerTile(
          currentColor: settingsProvider.primaryColor,
          onColorChanged: (Color color) {
            settingsProvider.setPrimaryColor(color);
            MyApp.updateAppState(
              context,
              newAccentColor: color,
              useSystemColor: false,
            );
          },
          title: LocaleKeys.accentColor.tr(),
          themeMode: themeMode,
        ),
      ],
    );
  }
}
