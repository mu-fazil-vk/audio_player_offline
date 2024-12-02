import 'package:flutter/material.dart';

Widget buildMoreOptionsSheet(context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add to Playlist'),
          onTap: () {
            // Handle add to playlist
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () {
            // Handle share
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.album),
          title: const Text('View Album'),
          onTap: () {
            // Handle view album
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('View Artist'),
          onTap: () {
            // Handle view artist
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
