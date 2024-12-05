import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/utils/calculate_columns.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/models/song_model.dart';
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
        title: Text(AppInfo().appName),
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
                        final audioList = snapshot.data!.$2!;
                        final totalItems = audioList.length;
                        final numberOfColumns = calculateColumns(totalItems);

                        return ListView.builder(
                          itemCount: numberOfColumns,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, columnIndex) {
                            final startIndex = columnIndex * 4;
                            final itemsInThisColumn =
                                min(4, max(0, totalItems - startIndex));

                            return SizedBox(
                              width: 300,
                              height: 300,
                              child: ListView.builder(
                                  itemCount: itemsInThisColumn,
                                  itemBuilder: (context, rowIndex) {
                                    final audioIndex = startIndex + rowIndex;
                                    final audioInfo = audioList[audioIndex];

                                    return CustomAudioListTile(
                                      onTap: () {
                                        context
                                            .read<AudioProvider>()
                                            .setPlaylist({
                                          'type': 'audio',
                                          'list': audioList
                                        }, audioIndex);
                                        context.push('/player');
                                      },
                                      audioInfo: audioInfo,
                                      columnCount: columnIndex + 1,
                                      isFavorite: context
                                          .watch<AudioDataProvider>()
                                          .likedSongs
                                          .contains(audioInfo),
                                    );
                                  }),
                            );
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
            if (context.watch<AudioDataProvider>().recentlyPlayed.isNotEmpty &&
                context.watch<AudioDataProvider>().allSongs.isNotEmpty) ...[
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
                          final audioId = context
                              .watch<AudioDataProvider>()
                              .recentlyPlayed[index]['id'];
                          print(
                              'allSongs: ${context.read<AudioDataProvider>().allSongs}');
                          final AudioModel? audioInfo = context
                              .read<AudioDataProvider>()
                              .allSongs
                              .firstWhere((element) {
                            return element.id.toString() == audioId.toString();
                          }, orElse: () => null);
                          return AudioCardWidget(
                            title: audioInfo?.title ?? 'Unknown Title',
                            artist: audioInfo?.artist ?? 'Unknown',
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
