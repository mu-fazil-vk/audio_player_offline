import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/providers/audio_data_provider.dart';
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
              onPressed: () {},
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
              child: FutureBuilder(
                  future: context.read<AudioDataProvider>().getUserPlaylists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              context.goNamed('favorites');
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
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      // image: const DecorationImage(
                                      //   image: AssetImage('assets/images/playlist.jpg'),
                                      //   fit: BoxFit.cover,
                                      // ),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    index == 0
                                        ? LocaleKeys.favorites.tr()
                                        : 'Playlist $index',
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
