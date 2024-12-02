import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/utils/format_duration.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomAudioListTile extends StatelessWidget {
  const CustomAudioListTile({
    super.key,
    this.isFavorite = false,
    this.isFavoriteScreen = false,
    this.audioInfo,
    this.columnCount = 1,
  });

  final bool isFavorite;
  final bool isFavoriteScreen;
  final SongModel? audioInfo;
  final int columnCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              kTestImage,
            ),
          ),
        ),
      ),
      title: Text(
        audioInfo?.title ?? 'Title',
        style: const TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        audioInfo?.artist ?? 'Artist',
      ),
      trailing: isFavoriteScreen
          ? Text(formatDuration(audioInfo?.duration ?? 0),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.grey, fontSize: 15))
          : isFavorite
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 17,
                    ),
                    Text(formatDuration(audioInfo?.duration ?? 0),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                )
              : null,
    );
  }
}
