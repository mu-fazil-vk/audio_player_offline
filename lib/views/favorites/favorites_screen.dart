import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data from the database once when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<AudioDataProvider>().updateFromDb();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppInfo().appName),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Center(
        child: Selector<AudioDataProvider, List>(
          selector: (_, audioDataProvider) => audioDataProvider.likedSongs,
          builder: (context, likedSongs, child) {
            return likedSongs.isNotEmpty
                ? ListView.builder(
                    itemCount: likedSongs.length,
                    itemBuilder: (context, index) {
                      final audioInfo = likedSongs[index];
                      return CustomAudioListTile(
                        showDuration: true,
                        audioInfo: audioInfo,
                      );
                    },
                  )
                : const Text('No favorite songs found!');
          },
        ),
      ),
    );
  }
}
