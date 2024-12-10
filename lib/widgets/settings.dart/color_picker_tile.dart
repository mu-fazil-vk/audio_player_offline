import 'package:flutter/material.dart';

class ColorPickerTile extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;
  final String title;
  final ThemeMode themeMode;
  final List<Color> colors;

  const ColorPickerTile({
    super.key,
    this.colors = const [
      Colors.transparent,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ],
    required this.currentColor,
    required this.onColorChanged,
    required this.title,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.color_lens,
          color: Theme.of(context).buttonTheme.colorScheme!.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      onTap: () => _showColorPicker(context),
      trailing: CircleAvatar(
        radius: 15,
        backgroundColor: themeMode == ThemeMode.light
            ? currentColor.withAlpha(150)
            : currentColor,
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final isSelected = color == currentColor;

            return GestureDetector(
              onTap: () {
                onColorChanged(color);
                Navigator.pop(context);
              },
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.5),
                          width: 7,
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
