import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/player/custom_control_button.dart';
import 'package:provider/provider.dart';

class AdvancedPlayerControllersWidget extends StatelessWidget {
  const AdvancedPlayerControllersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
        builder: (context, AudioProvider audioProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomControlButton(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedRepeat,
                color: Theme.of(context).buttonTheme.colorScheme!.primary),
            isSelected: audioProvider.repeatNotifier.value,
            onTap: () async => await audioProvider.toggleRepeat(),
          ),
          const SizedBox(width: 20),
          CustomControlButton(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedShuffle,
                color: Theme.of(context).buttonTheme.colorScheme!.primary),
            isSelected: audioProvider.shuffleNotifier.value,
            onTap: () async => await audioProvider.toggleShuffle(),
          ),
          const SizedBox(width: 20),
        ],
      );
    });
  }
}
