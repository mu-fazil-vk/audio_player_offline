import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class PlaylistViewScreen extends StatelessWidget {
  const PlaylistViewScreen({super.key, required this.playListId});

  final String playListId;

  @override
  Widget build(BuildContext context) {
    return Selector<AudioDataProvider,
        (List<String>, List<AudioModel>, String)>(
      selector: (_, provider) {
        final playlist = provider.customPlaylists
            .firstWhere((element) => element?.id == playListId);

        final songIds = playlist?.songs ?? [];
        final filteredSongs = provider.allSongs
            .where((song) => songIds.contains(song?.id.toString()))
            .toList() as List<AudioModel>;

        return (
          songIds,
          filteredSongs,
          playlist?.name ?? LocaleKeys.unknownTitle.tr()
        );
      },
      builder: (context, data, child) {
        final (_, songs, playlistName) = data;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              playlistName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: songs.isEmpty
                ? Center(
                    child: Text(LocaleKeys.noSongs.tr()),
                  )
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: CustomAudioListTile(
                          showDuration: true,
                          audioInfo: songs[index],
                          onTap: () {
                            context.read<AudioProvider>().setPlaylist(
                              {
                                'type': 'custom-playlist',
                                'list': songs,
                              },
                              index,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
