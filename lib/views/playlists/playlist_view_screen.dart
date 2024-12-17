import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
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
        (List<String>, List<AudioModel>, String)?>(
      selector: (_, provider) {
        final playlist = provider.customPlaylists
            .where((element) => element?.id == playListId)
            .firstOrNull;

        // If playlist is not found (e.g., after deletion), return null
        if (playlist == null) {
          return null;
        }

        final songIds = playlist.songs;
        final filteredSongs = provider.allSongs
            .where((song) => songIds.contains(song?.id.toString()))
            .toList() as List<AudioModel>;

        return (songIds, filteredSongs, playlist.name);
      },
      builder: (context, data, child) {
        // If data is null (playlist not found), navigate back to playlists
        if (data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/playlists');
          });
          return const SizedBox.shrink();
        }

        final (_, songs, playlistName) = data;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              playlistName,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMultiplicationSignCircle,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(LocaleKeys.deletePlaylist.tr()),
                        content: Text(LocaleKeys.deletePlaylistDesc.tr()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<AudioDataProvider>()
                                  .deleteCustomPlaylist(playListId);
                              Navigator.pop(ctx);
                            },
                            child: Text(LocaleKeys.yes.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: Text(LocaleKeys.no.tr()),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
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
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (direction) async {
                          if (context.mounted) {
                            context
                                .read<AudioDataProvider>()
                                .removeSongFromPlaylist(
                                    songs[index].id.toString(),
                                    playListId,
                                    context);
                          }
                        },
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
