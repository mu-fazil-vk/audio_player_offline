import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class AlbumSongsScreen extends StatelessWidget {
  const AlbumSongsScreen({super.key, required this.albumId});

  final int albumId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.albumSongs.tr()),
        ),
        body: Center(
          child: FutureBuilder(
              future: context.read<AudioDataProvider>().getAlbumsList(albumId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Center(child: Text(LocaleKeys.error.tr()));
                }
                if (snapshot.data?.$2 == null) {
                  return Center(child: Text(LocaleKeys.noData.tr()));
                }
                if (snapshot.data?.$1 != null) {
                  return Center(child: Text(snapshot.data!.$1.toString()));
                }
                if (snapshot.hasData && snapshot.data?.$2 != null) {
                  final albumSongs = snapshot.data!.$2;
                  return ListView.builder(
                    itemCount: albumSongs?.length ?? 0,
                    itemBuilder: (context, index) {
                      final audioInfo = albumSongs![index];
                      return Selector3<AudioDataProvider, AudioProvider,
                          AudioDataProvider, (bool, bool, bool)>(
                        selector: (_, audioData, audioProvider, likedData) => (
                          likedData.likedSongs.contains(audioInfo),
                          audioProvider.currentPlayingAudio == audioInfo,
                          audioProvider.isPlaying &&
                              audioProvider.currentPlayingAudio == audioInfo
                        ),
                        builder: (context, data, child) {
                          return CustomAudioListTile(
                            audioInfo: audioInfo,
                            showDuration: true,
                            isFavorite: data.$1, // From selector tuple
                            isPlaying: data.$2, // From selector tuple
                            onTap: () {
                              context.read<AudioProvider>().setPlaylist(
                                {
                                  'type': 'album',
                                  'list': albumSongs,
                                },
                                index,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text(LocaleKeys.error.tr()));
                }
              }),
        ));
  }
}
