import 'package:flutter/material.dart';
import 'package:music_player/widgets/player/advanced_player_controllers.dart';
import 'package:music_player/widgets/player/audio_banner.dart';
import 'package:music_player/widgets/player/basic_audio_controllers.dart';
import 'package:music_player/widgets/player/custom_slider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AudioBannerWidget(),
          const SizedBox(height: 20),
          Text(
            'Song Name',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Text(
            'Artist Name',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          //slider for music
          const CustomSlider(),

          //music controls

          const BasicAudioControllersWidget(),

          const SizedBox(height: 40),

          // More controls
          const AdvancedPlayerControllersWidget(),
        ],
      ),
    );
  }
}
