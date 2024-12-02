import 'package:flutter/material.dart';
import 'package:music_player/views/settings/sections/about.dart';
import 'package:music_player/views/settings/sections/audio_settings.dart';
import 'package:music_player/views/settings/sections/common_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Settings',
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonSettingsSection(),
              AudioSettingsSection(),
              AboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}
