import 'package:flutter/material.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class AllSongsScreen extends StatelessWidget {
  const AllSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allSongs = context.read<AudioDataProvider>().allSongs;
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Songs'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              final currentSong = allSongs[index];
              // Use Selector to only rebuild specific parts that change
              return Selector3<AudioDataProvider, AudioProvider,
                  AudioDataProvider, (bool, bool, bool)>(
                selector: (_, audioData, audioProvider, likedData) => (
                  // Only watch the specific states we need
                  likedData.likedSongs.contains(currentSong),
                  audioProvider.currentPlayingAudio == currentSong,
                  audioProvider.isPlaying &&
                      audioProvider.currentPlayingAudio == currentSong
                ),
                builder: (context, data, child) {
                  return CustomAudioListTile(
                    audioInfo: currentSong,
                    showDuration: true,
                    isFavorite: data.$1, // From selector tuple
                    isPlaying: data.$2, // From selector tuple
                    onTap: () {
                      context.read<AudioProvider>().setPlaylist({
                        'type': 'all_songs',
                        'list': allSongs,
                      }, index);
                    },
                  );
                },
              );
            },
          ),
        ));
  }
}
