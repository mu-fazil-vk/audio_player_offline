import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:music_player/widgets/common/custom_drop_down.dart';
import 'package:provider/provider.dart';

class AudioSettingsSection extends StatelessWidget {
  const AudioSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.audio.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        SwitchListTile(
          secondary: HugeIcon(
              icon: HugeIcons.strokeRoundedVoice,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          title: Text(LocaleKeys.audioBannerAnimation.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          value: settings.showAudioAnimation,
          onChanged: (value) => settings.setShowAudioVisualizer(value),
        ),
        10.ph,
        if (settings.showAudioAnimation)
          ListTile(
            leading: HugeIcon(
                icon: HugeIcons.strokeRoundedVoiceId,
                color: Theme.of(context).buttonTheme.colorScheme!.primary),
            title: Text(LocaleKeys.animations.tr(),
                style: Theme.of(context).textTheme.titleMedium),
            trailing: CustomDropdown(
                hint: 'Music',
                selectedItem: settings.audioAnimationStyle,
                items: [
                  'Music',
                  'Music 1',
                  'Music 2',
                  'Music 3',
                  'Music 4',
                  'Music 5'
                ]
                    .map((style) => DropdownMenuItem(
                          value: style.replaceAll(' ', ''),
                          child: Text(style),
                        ))
                    .toList(),
                // remove spaces from the value
                onChanged: (value) =>
                    settings.setVisualizerStyle(value!.replaceAll(' ', ''))),
          ),
        10.ph,
        SwitchListTile(
          secondary: HugeIcon(
              icon: HugeIcons.strokeRoundedPlayCircle,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          title: Text(LocaleKeys.useClassicControls.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          value: settings.isClassicPlayer,
          onChanged: (value) => settings.setIsClassicPlayer(value),
        ),
        ListTile(
          title: Text(LocaleKeys.clearData.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(LocaleKeys.clearDataDesc.tr()),
          leading: Icon(Icons.delete,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(LocaleKeys.clearAllData.tr()),
                content: Text(LocaleKeys.clearAllDataDesc.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      settings.clearAllData(context);
                      Navigator.pop(context);
                    },
                    child: Text(LocaleKeys.clear.tr()),
                  ),
                ],
              ),
            );
          },
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.clearRecentlyPlayed.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          leading: Icon(Icons.do_not_disturb_alt_sharp,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('${LocaleKeys.clearRecentlyPlayed.tr()}?'),
                content: Text(LocaleKeys.clearRecentlyPlayedDesc.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AudioDataProvider>().clearRecentlyPlayed();
                      context
                          .read<AudioProvider>()
                          .setCurrentPlayingAudio(null);
                      Navigator.pop(context);
                    },
                    child: Text(LocaleKeys.clear.tr()),
                  ),
                ],
              ),
            );
          },
        ),
        20.ph,
      ],
    );
  }
}
