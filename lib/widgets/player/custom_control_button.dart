import 'package:flutter/material.dart';

class CustomControlButton extends StatelessWidget {
  const CustomControlButton({
    super.key,
    required this.icon,
  });

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        child: icon,
      ),
    );
  }
}
