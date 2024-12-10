import 'package:flutter/material.dart';

Widget buildMoreOptionsSheet(BuildContext context, {VoidCallback? addPlaylist}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add to Playlist'),
          onTap: addPlaylist,
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () {
            // Handle share
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
  
}
