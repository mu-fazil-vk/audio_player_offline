import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/format_duration.dart';
import 'package:music_player/models/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomAudioListTile extends StatelessWidget {
  /// A custom audio list tile that displays information about an audio item.
  ///
  /// The widget shows different UI elements based on whether the audio is marked as
  /// a favorite, whether it's being played, and other parameters such as showing
  /// the duration.
  const CustomAudioListTile({
    super.key,
    this.isFavorite = false, // Whether the audio is a favorite.
    this.audioInfo, // Audio information that contains title, artist, and duration.
    this.columnCount =
        1, // Number of columns to layout the content (default is 1).
    this.isPlaying =
        false, // Whether to show the playing animation on the trailing.
    this.showDuration = false, // Whether to show the duration on the trailing.
    this.onTap, // Callback function when the tile is tapped.
    this.titleWidget, // Title widget to display in the tile.
  });

  /// Whether the audio is marked as a favorite.
  /// If true, it shows a star icon along with the duration.
  final bool isFavorite;

  /// The audio information, typically includes title, artist, and duration.
  final AudioModel? audioInfo;

  /// The number of columns to layout the content in the widget.
  /// This is used to control how the layout is structured, with 1 as the default.
  final int columnCount;

  /// Whether the audio is currently playing.
  /// If true, it shows a play icon in the trailing to indicate playback.
  final bool isPlaying;

  /// Whether to show the duration of the audio in the trailing.
  /// If true, the duration will always be displayed, regardless of `isFavoriteScreen` or `isFavorite`.
  final bool showDuration;

  /// A callback function that is called when the tile is tapped.
  final VoidCallback? onTap;

  /// The title widget to display in the tile.
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: QueryArtworkWidget(
          id: audioInfo!.id,
          type: ArtworkType.AUDIO,
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
      title: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: titleWidget ??
            SizedBox(
              height: 35,
              child: Marquee(
                startAfter: const Duration(seconds: 3),
                pauseAfterRound: const Duration(seconds: 1),
                velocity: 30,
                text: audioInfo?.title ?? LocaleKeys.unknownTitle.tr(),
              ),
            ),
      ),
      subtitle: Text(
        audioInfo?.artist ?? LocaleKeys.unknownArtist.tr(),
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: isFavorite
          // First, check if it's a favorite
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.star,
                  size: 17,
                ),
                Text(
                  formatDuration(audioInfo?.duration ?? 0),
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            )
          : isPlaying
              // If not favorite, check if it's playing
              ? SizedBox(
                  height: 25,
                  width: 30,
                  child: Lottie.asset(
                    width: 30,
                    height: 20,
                    'assets/lottie/music.json',
                  ))
              : showDuration
                  // If neither, check if we should show the duration
                  ? Text(
                      formatDuration(audioInfo?.duration ?? 0),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                    )
                  : null, // If none of the conditions are met, show nothing
    );
  }
}
