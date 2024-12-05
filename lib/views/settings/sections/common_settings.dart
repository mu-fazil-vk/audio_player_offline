import 'package:flutter/material.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/main.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/widgets/common/custom_drop_down.dart';
import 'package:music_player/widgets/settings.dart/color_picker_tile.dart';
import 'package:provider/provider.dart';

final _themeModes = [
  const DropdownMenuItem(
    value: "system",
    child: Text("System"),
  ),
  const DropdownMenuItem(
    value: "light",
    child: Text("Light"),
  ),
  const DropdownMenuItem(
    value: "dark",
    child: Text("Dark"),
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
          'Common',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title:
              Text('Language', style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('Select your language.'),
          leading: const Icon(Icons.language),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title: Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          leading: const Icon(Icons.dark_mode_rounded),
          trailing: CustomDropdown(
              items: _themeModes,
              hint: 'Dark',
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
          title: 'Accent Color',
          themeMode: themeMode,
        ),
      ],
    );
  }
}
