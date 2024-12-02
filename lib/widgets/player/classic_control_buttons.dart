import 'package:flutter/material.dart';

class ClassicControlButtons extends StatelessWidget {
  const ClassicControlButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_filled),
            iconSize: 64,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.repeat),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
