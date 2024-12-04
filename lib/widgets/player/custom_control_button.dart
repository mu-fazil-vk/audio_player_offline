import 'package:flutter/material.dart';

class CustomControlButton extends StatelessWidget {
  const CustomControlButton({
    super.key,
    required this.icon,
    this.onTap,
    this.isSelected = false,
  });

  final Widget? icon;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .buttonTheme
              .colorScheme!
              .primaryContainer
              .withOpacity(isSelected ? 1 : 0.5),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
