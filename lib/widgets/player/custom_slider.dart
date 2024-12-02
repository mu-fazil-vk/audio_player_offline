import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  CustomSliderState createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  double _currentSliderValue = 12; // Start at 00:12 (in seconds)

  // Hardcoded start and end times
  final String startTime = "00:12";
  final String endTime = "01:56";

  // Convert seconds to mm:ss format
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startTime,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  endTime,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Slider(
            value: _currentSliderValue,
            min: 0,
            max: 116, // 01:56 in seconds
            divisions: 116, // Max value of 116 for 01:56
            label: formatTime(_currentSliderValue.toInt()),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
