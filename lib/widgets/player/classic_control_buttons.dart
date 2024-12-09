import 'package:flutter/material.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:provider/provider.dart';

class ClassicControlButtons extends StatelessWidget {
  const ClassicControlButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Consumer<AudioProvider>(
          builder: (context, AudioProvider audioProvider, child) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(
              icon: Icon(audioProvider.shuffleNotifier.value
                  ? Icons.shuffle_on
                  : Icons.shuffle),
              onPressed: () async {
                await audioProvider.toggleShuffle();
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () async {
                await audioProvider.skipToPrevious();
              },
            ),
            IconButton(
              icon: Icon(audioProvider.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled),
              iconSize: 64,
              onPressed: () async {
                if (audioProvider.isPlaying) {
                  await audioProvider.pause();
                } else {
                  await audioProvider.play();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () async {
                await audioProvider.skipToNext();
              },
            ),
            IconButton(
              icon: Icon(audioProvider.repeatNotifier.value
                  ? Icons.repeat_on
                  : Icons.repeat),
              onPressed: () async {
                await audioProvider.toggleRepeat();
              },
            ),
          ],
        );
      }),
    );
  }
}
