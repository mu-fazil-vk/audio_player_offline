import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniMusicPlayer extends StatelessWidget {
  final VoidCallback onTap;

  const MiniMusicPlayer({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.0,
          color: Theme.of(context).cardColor,
          child: Consumer<AudioProvider>(
              builder: (context, AudioProvider audioProvider, child) {
            return Row(
              children: [
                // Album Art
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Hero(
                    key: const ValueKey('image'),
                    tag: 'image',
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      child: QueryArtworkWidget(
                        id: context
                            .watch<AudioProvider>()
                            .currentPlayingAudio!
                            .id,
                        type: ArtworkType.AUDIO,
                        artworkQuality: FilterQuality.medium,
                        keepOldArtwork: true,
                        artworkBorder: BorderRadius.circular(15),
                        nullArtworkWidget: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.music_note,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Song Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioProvider.currentPlayingAudio?.title ??
                              LocaleKeys.unknownTitle.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          audioProvider.currentPlayingAudio?.artist ??
                              LocaleKeys.unknownArtist.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Control Buttons
                Row(
                  children: [
                    IconButton(
                      icon: HugeIcon(
                        icon: audioProvider.isPlaying
                            ? HugeIcons.strokeRoundedPause
                            : HugeIcons.strokeRoundedPlay,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      onPressed: () async {
                        if (audioProvider.isPlaying) {
                          await audioProvider.pause();
                        } else {
                          await audioProvider.play();
                        }
                      },
                    ),
                    IconButton(
                        icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedNext,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary),
                        onPressed: () async =>
                            await audioProvider.skipToNext()),
                    10.pw,
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
