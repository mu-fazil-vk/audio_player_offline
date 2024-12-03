import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/utils/calculate_columns.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/audio_card.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () async {
                //context.push('/player');
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Center(
                child: FutureBuilder(
                    future: context.read<AudioDataProvider>().getAllSongs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      if (snapshot.hasData && snapshot.data?.$2 != null) {
                        final audioList = snapshot.data?.$2;
                        final totalItems = (audioList?.length ?? 0);
                        final numberOfColumns = calculateColumns(totalItems);
                        return ListView.builder(
                          itemCount: numberOfColumns > 0 ? numberOfColumns : 0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final columnCount = index + 1;
                            final remainingItems =
                                audioList!.length - (columnCount) * 4;
                            final itemsInThisColumn =
                                min(4, max(0, remainingItems));
                            return SizedBox(
                                width: 300,
                                height: 300,
                                child: ListView.builder(
                                    itemCount: itemsInThisColumn,
                                    itemBuilder: (context, index) {
                                      final newIndex = index + columnCount * 4;
                                      final audioInfo = audioList[newIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          // context
                                          //     .read<AudioDataProvider>()
                                          //     .updateRecentlyPlayed(audioInfo);
                                          context
                                              .read<AudioProvider>()
                                              .setPlaylist({
                                            'title':
                                                '003150_siren-test-prague-3-52475',
                                            'list': audioList
                                                .map((element) => {
                                                      '_data': element.data,
                                                      'title': element.title,
                                                      'path': element.data,
                                                    })
                                                .toList()
                                          }, index);
                                        },
                                        child: CustomAudioListTile(
                                          audioInfo: audioInfo,
                                          columnCount: index + 1,
                                          isFavorite: context
                                              .watch<AudioDataProvider>()
                                              .likedSongs
                                              .contains(audioInfo),
                                        ),
                                      );
                                    }));
                          },
                        );
                      }
                      if (snapshot.hasData && snapshot.data?.$2 == null) {
                        return const Text('No data');
                      } else {
                        return const Text('Error');
                      }
                    }),
              ),
            ),
            // Albums
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Albums',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  10.ph,
                  SizedBox(
                    height: 165,
                    width: double.infinity,
                    child: FutureBuilder(
                        future: context
                            .read<AudioDataProvider>()
                            .getAllAlbumsList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 75,
                              width: 75,
                              // child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.data?.$2 == null) {
                            return const Text('No data');
                          }
                          if (snapshot.data?.$1 != null) {
                            return Text(snapshot.data!.$1.toString());
                          }
                          if (snapshot.hasData && snapshot.data?.$2 != null) {
                            final albumList = snapshot.data?.$2;
                            return ListView.separated(
                              itemCount: (albumList?.length ?? 0) > 4
                                  ? 4
                                  : (albumList?.length ?? 0),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => 30.pw,
                              itemBuilder: (context, index) {
                                return AudioCardWidget(
                                  title: albumList![index].album,
                                  artist: albumList[index].artist ?? 'Unknown',
                                );
                              },
                            );
                          } else {
                            return const Text('Error');
                          }
                        }),
                  ),
                ],
              ),
            ),
            // Recently Played
            if (context
                .watch<AudioDataProvider>()
                .recentlyPlayed
                .isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Played',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    10.ph,
                    SizedBox(
                      height: 165,
                      width: double.infinity,
                      child: ListView.separated(
                        itemCount: context
                            .watch<AudioDataProvider>()
                            .recentlyPlayed
                            .length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 30),
                        itemBuilder: (context, index) {
                          final audioInfo = context
                              .watch<AudioDataProvider>()
                              .recentlyPlayed[index];
                          return AudioCardWidget(
                            title: audioInfo.title,
                            artist: audioInfo.artist,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
