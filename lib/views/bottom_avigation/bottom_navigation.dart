import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/views/player/transition_animations.dart';
import 'package:music_player/views/player/full_screen_player.dart';
import 'package:music_player/views/player/mini_music_player.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key, required this.body});
  final StatefulNavigationShell body;

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final _selectedIndex = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // Main content
            Positioned.fill(
              bottom: 70, // NavigationBar height + MiniPlayer height
              child: widget.body,
            ),

            // Expandable Music Player
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniMusicPlayer(
                onTap: () {
                  // Get the mini player's position and size
                  // final RenderBox miniPlayerBox =
                  //     context.findRenderObject() as RenderBox;
                  // final Offset offset =
                  //     miniPlayerBox.localToGlobal(Offset.zero);
                  // final Rect miniPlayerRect = offset & miniPlayerBox.size;

                  // Choose one of the animation styles:

                  // Slide Up Animation
                  Navigator.push(
                    context,
                    SlideUpPageRoute(
                      child: const FullScreenMusicPlayer(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex.value,
          onDestinationSelected: (index) {
            widget.body.goBranch(
              index,
              initialLocation: index == widget.body.currentIndex,
            );
            setState(() {
              _selectedIndex.value = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            NavigationDestination(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ));
  }
}
