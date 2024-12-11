import 'package:flutter/material.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Widget buildMoreOptionsSheet(BuildContext context,
    {VoidCallback? addPlaylist}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add to Playlist'),
          onTap: addPlaylist,
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () async {
            await Share.shareXFiles(
              [XFile(context.read<AudioProvider>().currentPlayingAudio!.data)],
            );
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
