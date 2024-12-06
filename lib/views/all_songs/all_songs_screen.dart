import 'package:flutter/material.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class AllSongsScreen extends StatelessWidget {
  const AllSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Songs'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return CustomAudioListTile(
                audioInfo: context.read<AudioDataProvider>().allSongs[index],
                showDuration: true,
                isFavorite: context
                    .watch<AudioDataProvider>()
                    .likedSongs
                    .contains(
                        context.read<AudioDataProvider>().allSongs[index]),
                isPlaying: context.watch<AudioProvider>().currentPlayingAudio ==
                    context.read<AudioDataProvider>().allSongs[index],
                onTap: () {
                  context.read<AudioProvider>().setPlaylist({
                    'type': 'all_songs',
                    'list': context.read<AudioDataProvider>().allSongs,
                  }, index);
                },
              );
            },
          ),
        ));
  }
}
