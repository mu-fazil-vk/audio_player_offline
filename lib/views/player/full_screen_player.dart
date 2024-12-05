import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:music_player/widgets/player/advanced_player_controllers.dart';
import 'package:music_player/widgets/player/audio_banner.dart';
import 'package:music_player/widgets/player/basic_audio_controllers.dart';
import 'package:music_player/widgets/player/custom_slider.dart';
import 'package:music_player/widgets/player/more_options_bottom_sheet.dart';
import 'package:provider/provider.dart';

class FullScreenMusicPlayer extends StatefulWidget {
  const FullScreenMusicPlayer({super.key});

  @override
  State<FullScreenMusicPlayer> createState() => _FullScreenMusicPlayerState();
}

class _FullScreenMusicPlayerState extends State<FullScreenMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show bottom sheet with more options
              showModalBottomSheet(
                context: context,
                builder: (context) => buildMoreOptionsSheet(context),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<AudioProvider>(
            builder: (context, AudioProvider audioProvider, child) {
          return Column(
            children: [
              // Album Art
              Hero(
                  key: const ValueKey('image'),
                  tag: 'image',
                  child: AudioBannerWidget(
                    audioId: audioProvider.currentPlayingAudio!.id,
                  )),
              // Song Info
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Marquee(
                        startAfter: const Duration(seconds: 3),
                        blankSpace: 100,
                        pauseAfterRound: const Duration(seconds: 3),
                        velocity: 30,
                        text: audioProvider.currentPlayingAudio?.title ??
                            'Unknown Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    8.ph,
                    Text(
                      audioProvider.currentPlayingAudio?.artist ??
                          'Unknown Artist',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Progress Bar
              const CustomSlider(),
              //ToDo:  Classic Control Buttons
              //const ClassicControlButtons(),

              const BasicAudioControllersWidget(),

              40.ph,

              // More controls
              const AdvancedPlayerControllersWidget(),
              20.ph,
              GestureDetector(
                onVerticalDragEnd: (details) => showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (context) => _buildQueueSheet(),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowUp01,
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      size: 30),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQueueSheet() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            itemCount: audioProvider.currentPlaylist['list'].length,
            itemBuilder: (context, index) {
              final audioInfo = audioProvider.currentPlaylist['list'][index];
              return CustomAudioListTile(
                onTap: () async => await audioProvider.playTrack(index),
                audioInfo: audioInfo,
                isFavorite: context
                    .watch<AudioDataProvider>()
                    .likedSongs
                    .contains(audioInfo),
                isPlaying: audioProvider.currentPlayingAudio == audioInfo,
                showDuration: true,
              );
            },
          ));
    });
  }
}
