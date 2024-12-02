import 'package:flutter/material.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/widgets/common/custom_drop_down.dart';

final _themeModes = [
  const DropdownMenuItem(
    value: "system",
    child: Text("System"),
  ),
  const DropdownMenuItem(
    value: "light",
    child: Text("Light"),
  ),
  const DropdownMenuItem(
    value: "dark",
    child: Text("Dark"),
  ),
];

class CommonSettingsSection extends StatelessWidget {
  const CommonSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Common',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title:
              Text('Language', style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('Select your language.'),
          leading: const Icon(Icons.language),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title: Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          leading: const Icon(Icons.dark_mode_rounded),
          trailing: CustomDropdown(
            items: _themeModes,
            hint: 'Dark',
            onChanged: (_) {},
          ),
        ),
        20.ph,
      ],
    );
  }
}
