import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/player/custom_control_button.dart';
import 'package:provider/provider.dart';

class BasicAudioControllersWidget extends StatelessWidget {
  const BasicAudioControllersWidget({
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
                  icon: HugeIcons.strokeRoundedPrevious,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary),
              onTap: () async => await audioProvider.skipToPrevious()),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              if (audioProvider.isPlaying) {
                await audioProvider.pause();
              } else {
                await audioProvider.play();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 70,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .buttonTheme
                    .colorScheme!
                    .primary
                    .withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: HugeIcon(
                icon: audioProvider.isPlaying
                    ? HugeIcons.strokeRoundedPause
                    : HugeIcons.strokeRoundedPlay,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Next Button
          CustomControlButton(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedNext,
                color: Theme.of(context).buttonTheme.colorScheme!.primary),
            onTap: () async => await audioProvider.skipToNext(),
          ),
        ],
      );
    });
  }
}
