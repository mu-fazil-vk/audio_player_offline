import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';

class CustomAudioListTileWithHighlight extends StatelessWidget {
  final AudioModel audioInfo;
  final bool showDuration;
  final bool isFavorite;
  final VoidCallback onTap;
  final String searchQuery;
  final bool isPlaying;

  const CustomAudioListTileWithHighlight({
    super.key,
    required this.audioInfo,
    required this.showDuration,
    required this.isFavorite,
    required this.onTap,
    required this.searchQuery,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAudioListTile(
      audioInfo: audioInfo,
      showDuration: showDuration,
      isFavorite: isFavorite,
      onTap: onTap,
      isPlaying: isPlaying,
      // Override the title with our highlighted version
      titleWidget: _buildHighlightedText(context, audioInfo.title),
    );
  }

  Widget _buildHighlightedText(BuildContext context, String text) {
    if (searchQuery.isEmpty) {
      return Text(text, overflow: TextOverflow.ellipsis);
    }

    final matches = RegExp(searchQuery, caseSensitive: false).allMatches(text);
    if (matches.isEmpty) {
      return Text(text, overflow: TextOverflow.ellipsis);
    }

    final List<TextSpan> spans = [];
    int currentPos = 0;

    for (final match in matches) {
      if (match.start != currentPos) {
        spans.add(TextSpan(
          text: text.substring(currentPos, match.start),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ));
      currentPos = match.end;
    }

    if (currentPos != text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos, text.length),
      ));
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(overflow: TextOverflow.ellipsis),
        children: spans,
      ),
    );
  }
}
