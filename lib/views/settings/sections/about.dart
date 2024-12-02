import 'package:flutter/material.dart';
import 'package:music_player/core/utils/size_extension.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title:
              Text('Developer', style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('Muhammed Fazil vk'),
          leading: const Icon(Icons.code),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title: Text('Translators',
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('Some golden minded people.'),
          leading: const Icon(Icons.translate),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title:
              Text('Version', style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('0.0.1'),
          leading: const Icon(Icons.info_outline),
          onTap: () {},
        ),
        10.ph,
        ListTile(
          title:
              Text('Licence', style: Theme.of(context).textTheme.titleMedium),
          leading: const Icon(Icons.change_history),
          onTap: () {},
        ),
        20.ph,
      ],
    );
  }
}
