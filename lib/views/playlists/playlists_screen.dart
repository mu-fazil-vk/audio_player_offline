import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/widgets/common/add_playlist_dialogue.dart';
import 'package:provider/provider.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          LocaleKeys.playlists.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => addPlaylistDialogue(context),
                );
              },
              icon: const Icon(Icons.add),
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              label: Text(
                LocaleKeys.playlists.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
            20.ph,
            Expanded(
              child: Selector<AudioDataProvider,
                      (List<CustomPlaylistModel?>, int)>(
                  selector: (_, provider) => (
                        provider.customPlaylists,
                        provider.likedSongs.length,
                      ),
                  builder: (context, data, child) {
                    final (customPlaylists, likedSongsCount) = data;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: customPlaylists.length + 1,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              context.goNamed('favorites');
                            } else {
                              context.goNamed('playlist-view', pathParameters: {
                                'id': customPlaylists[index - 1]!.id
                              });
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      if (index != 0)
                                        Positioned(
                                          right: 10,
                                          top: 5,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              index == 0
                                                  ? likedSongsCount.toString()
                                                  : '${customPlaylists[index - 1]?.songs.length ?? 0}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      Container(
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: index == 0
                                            ? Center(
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 40,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    index == 0
                                        ? LocaleKeys.favorites.tr()
                                        : customPlaylists[index - 1]!.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
