import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
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
          title: Text(LocaleKeys.addToPlaylist.tr()),
          onTap: addPlaylist,
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: Text(LocaleKeys.share.tr()),
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
