import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/player/custom_control_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AdvancedPlayerControllersWidget extends StatelessWidget {
  const AdvancedPlayerControllersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AudioProvider, Tuple2<bool, bool>>(
      selector: (context, provider) => Tuple2(
        provider.repeatNotifier.value,
        provider.shuffleNotifier.value,
      ),
      builder: (context, state, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomControlButton(
              icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedRepeat,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary),
              isSelected: state.item1,
              onTap: () async =>
                  await context.read<AudioProvider>().toggleRepeat(),
            ),
            const SizedBox(width: 20),
            CustomControlButton(
              icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedShuffle,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary),
              isSelected: state.item2,
              onTap: () async =>
                  await context.read<AudioProvider>().toggleShuffle(),
            ),
            const SizedBox(width: 20),
            Selector<AudioDataProvider, bool>(
                selector: (context, provider) => provider.likedSongs.contains(
                    context
                        .read<AudioProvider>()
                        .currentPlayingAudio!
                        .id
                        .toString()),
                builder: (context, isLiked, child) {
                  return CustomControlButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      weight: 0.3,
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                    isSelected: isLiked,
                    onTap: () =>
                        context.read<AudioDataProvider>().toggleSongLike(
                              context
                                  .read<AudioProvider>()
                                  .currentPlayingAudio!
                                  .id
                                  .toString(),
                              !isLiked,
                            ),
                  );
                }),
          ],
        );
      },
    );
  }
}
