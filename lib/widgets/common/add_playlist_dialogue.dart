import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:provider/provider.dart';

AlertDialog addPlaylistDialogue(BuildContext context) {
  return AlertDialog(
    title: Text(LocaleKeys.addToPlaylist.tr()),
    content: SizedBox(
      height:
          context.read<AudioDataProvider>().customPlaylists.isEmpty ? 140 : 250,
      child: Column(
        children: [
          SizedBox(
            height: context.read<AudioDataProvider>().customPlaylists.isEmpty
                ? 80
                : 200,
            child: context.read<AudioDataProvider>().customPlaylists.isEmpty
                ? Center(
                    child: Text(LocaleKeys.noPlaylists.tr()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // List of playlists
                        ...context
                            .watch<AudioDataProvider>()
                            .customPlaylists
                            .map((playlist) {
                          return ListTile(
                            leading: const Icon(Icons.playlist_play),
                            title: Text(playlist!.name),
                            trailing: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Text('${playlist.songs.length}',
                                    style: const TextStyle(fontSize: 16))),
                            onTap: () {
                              // Add the current song to the selected playlist
                              context
                                  .read<AudioDataProvider>()
                                  .addSongToPlaylist(
                                      context
                                          .read<AudioProvider>()
                                          .currentPlayingAudio!
                                          .id
                                          .toString(),
                                      playlist.id);
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
          ),
          // Add new playlist
          TextButton(
            child: Text(LocaleKeys.newPlaylist.tr()),
            onPressed: () {
              // Show dialog to create new playlist
              showDialog(
                context: context,
                builder: (ctx) {
                  final TextEditingController controller =
                      TextEditingController();
                  return AlertDialog(
                    title: Text(LocaleKeys.newPlaylist.tr()),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.playlistName.tr(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(LocaleKeys.cancel.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          // Create new playlist
                          context
                              .read<AudioDataProvider>()
                              .createCustomPlaylist(controller.text, null);
                          Navigator.pop(context);
                        },
                        child: Text(LocaleKeys.create.tr()),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
