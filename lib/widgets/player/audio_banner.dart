import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioBannerWidget extends StatelessWidget {
  const AudioBannerWidget({
    super.key,
    required this.audioId,
  });

  final int audioId;

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: Swiper(
        onIndexChanged: (value) =>
            context.read<AudioProvider>().playTrack(value),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.width - 100,
              width: MediaQuery.of(context).size.width - 100,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: QueryArtworkWidget(
                id: audioId,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: appSettings.showAudioVisualizer
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: Lottie.asset(
                            height: 100,
                            width: 100,
                            'assets/lottie/${appSettings.visualizerStyle.toLowerCase()}.json',
                          ))
                      : HugeIcon(
                          icon: HugeIcons.strokeRoundedMusicNote04,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 70,
                        ),
                ),
              ),
            ),
          );
        },
        itemCount: context.read<AudioProvider>().currentPlaylist['list'].length,
      ),
    );
  }
}
