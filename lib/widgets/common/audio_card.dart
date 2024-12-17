import 'package:flutter/material.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioCardWidget extends StatelessWidget {
  const AudioCardWidget({
    super.key,
    required this.audioId,
    required this.title,
    required this.artist,
    this.isAlbum = false,
    this.onTap,
  });
  final int audioId;
  final String title;
  final String artist;
  final bool isAlbum;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: QueryArtworkWidget(
                id: audioId,
                type: isAlbum ? ArtworkType.ALBUM : ArtworkType.AUDIO,
                artworkQuality: FilterQuality.high,
                artworkBorder: BorderRadius.circular(15),
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context)
                        .buttonTheme
                        .colorScheme!
                        .primary
                        .withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.music_note,
                  ),
                ),
              ),
            ),
            7.ph,
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            5.ph,
            Text(
              artist,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
