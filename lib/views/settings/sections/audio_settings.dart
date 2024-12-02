import 'package:flutter/material.dart';
import 'package:music_player/core/utils/size_extension.dart';

class AudioSettingsSection extends StatelessWidget {
  const AudioSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tools',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title: Text('Clear datas',
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text(
              'Clear all stored data (playback position, recent play, etc.).'),
          leading: const Icon(Icons.delete),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title: Text('Clear search history',
              style: Theme.of(context).textTheme.titleMedium),
          leading: const Icon(Icons.history),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title: Text('Clear recently played',
              style: Theme.of(context).textTheme.titleMedium),
          leading: const Icon(Icons.do_not_disturb_alt_sharp),
          onTap: () {},
        ),
        20.ph,
      ],
    );
  }
}
