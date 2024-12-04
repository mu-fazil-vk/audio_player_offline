import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AudioDataProvider>().updateFromDb();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Center(
        child: context.read<AudioDataProvider>().likedSongs.isNotEmpty
            ? ListView.builder(
                itemCount: context.read<AudioDataProvider>().likedSongs.length,
                itemBuilder: (context, index) {
                  final audioInfo =
                      context.read<AudioDataProvider>().likedSongs[index];
                  return CustomAudioListTile(
                    showDuration: true,
                    audioInfo: audioInfo,
                  );
                })
            : const Text('No favorite songs found!'),
      ),
    );
  }
}
