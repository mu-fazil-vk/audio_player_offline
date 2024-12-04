import 'package:flutter/material.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:provider/provider.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});
  @override
  CustomSliderState createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  bool _isDragging = false;
  double _dragValue = 0;

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          // Use drag value if currently dragging, otherwise use actual position
          final position = _isDragging
              ? _dragValue
              : audioProvider.position.inSeconds.toDouble();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position.toInt()),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      formatTime(audioProvider.duration.inSeconds),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Slider(
                value: position.clamp(
                    0, audioProvider.duration.inSeconds.toDouble()),
                min: 0,
                max: audioProvider.duration.inSeconds.toDouble(),
                label: formatTime(position.toInt()),
                onChangeStart: (value) {
                  _isDragging = true;
                  _dragValue = value;
                },
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  // For smoother seeking, we can optionally add this:
                  // audioProvider.seek(Duration(seconds: value.toInt()));
                },
                onChangeEnd: (value) {
                  _isDragging = false;
                  audioProvider.seek(Duration(seconds: value.toInt()));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
