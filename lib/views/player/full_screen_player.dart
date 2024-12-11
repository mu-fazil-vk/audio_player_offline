import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:music_player/widgets/player/advanced_player_controllers.dart';
import 'package:music_player/widgets/player/audio_banner.dart';
import 'package:music_player/widgets/player/basic_audio_controllers.dart';
import 'package:music_player/widgets/player/custom_slider.dart';
import 'package:music_player/widgets/player/more_options_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
                builder: (ctx) {
                  return buildMoreOptionsSheet(context, addPlaylist: () {
                    Navigator.pop(context);
                    // Handle add to playlist, show dialog to select playlist or create new playlist
                    showDialog(
                      context: context,
                      builder: (context) {
                        return addPlaylistDialogue(context);
                      },
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Selector<AudioProvider, AudioModel?>(
          selector: (context, provider) => provider.currentPlayingAudio,
          builder: (context, currentAudio, child) {
            return Column(
              children: [
                // Album Art
                Hero(
                    key: const ValueKey('image'),
                    tag: 'image',
                    child: AudioBannerWidget(
                      audioId: currentAudio!.id,
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
                          text: currentAudio.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      8.ph,
                      Text(
                        currentAudio.artist ?? 'Unknown Artist',
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
                //ToDo: Classic Control Buttons
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
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                        size: 30),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  AlertDialog addPlaylistDialogue(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Playlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // List of playlists
          ...context.watch<AudioDataProvider>().customPlaylists.map((playlist) {
            return ListTile(
              leading: const Icon(Icons.playlist_play),
              title: Text(playlist!.name),
              trailing: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text('${playlist.songs.length}',
                      style: const TextStyle(fontSize: 16))),
              onTap: () {
                // Add the current song to the selected playlist
                context.read<AudioDataProvider>().addSongToPlaylist(
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
          // Add new playlist
          TextButton(
            child: const Text('Create New Playlist'),
            onPressed: () {
              // Show dialog to create new playlist
              showDialog(
                context: context,
                builder: (ctx) {
                  final TextEditingController controller =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text('Create New Playlist'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Playlist Name',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Create new playlist
                          context
                              .read<AudioDataProvider>()
                              .createCustomPlaylist(controller.text, null);
                          Navigator.pop(context);
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQueueSheet() {
    return Selector<AudioProvider, List>(
      selector: (context, provider) => provider.currentPlaylist['list'],
      builder: (context, playlist, child) {
        return Consumer<AudioDataProvider>(
          builder: (context, audioDataProvider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  final audioInfo = playlist[index];

                  return Selector2<AudioDataProvider, AudioProvider,
                      Tuple2<bool, bool>>(
                    selector: (context, audioDataProvider, audioProvider) {
                      final isFavorite =
                          audioDataProvider.likedSongs.contains(audioInfo);
                      final isPlaying =
                          audioProvider.currentPlayingAudio == audioInfo;
                      return Tuple2(isFavorite, isPlaying);
                    },
                    builder: (context, state, child) {
                      return CustomAudioListTile(
                        onTap: () async => await context
                            .read<AudioProvider>()
                            .playTrack(index),
                        audioInfo: audioInfo,
                        isFavorite: state.item1,
                        isPlaying: state.item2,
                        showDuration: true,
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
