import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/utils/size_extension.dart';

class AudioCardWidget extends StatelessWidget {
  const AudioCardWidget({
    super.key, required this.title, required this.artist,
  });
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 110,
          width: 110,
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
    );
  }
}
