import 'package:flutter/material.dart';
import 'package:music_player/widgets/player/custom_control_button.dart';

class AdvancedPlayerControllersWidget extends StatelessWidget {
  const AdvancedPlayerControllersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomControlButton(icon: Icon(Icons.repeat)),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .buttonTheme
                  .colorScheme!
                  .primaryContainer
                  .withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shuffle,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        const CustomControlButton(icon: Icon(Icons.shuffle)),
      ],
    );
  }
}
