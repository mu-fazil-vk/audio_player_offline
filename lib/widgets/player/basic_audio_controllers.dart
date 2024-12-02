import 'package:flutter/material.dart';
import 'package:music_player/widgets/player/custom_control_button.dart';

class BasicAudioControllersWidget extends StatelessWidget {
  const BasicAudioControllersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomControlButton(icon: Icon(Icons.skip_previous)),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 70,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).buttonTheme.colorScheme!.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Next Button
        const CustomControlButton(icon: Icon(Icons.skip_next)),
      ],
    );
  }
}
