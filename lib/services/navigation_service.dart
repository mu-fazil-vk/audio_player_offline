import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/views/album_songs/album_songs_screen.dart';
import 'package:music_player/views/all_songs/all_songs_screen.dart';
import 'package:music_player/views/bottom_avigation/bottom_navigation.dart';
import 'package:music_player/views/playlists/favorites_screen.dart';
import 'package:music_player/views/home/home_screen.dart';
import 'package:music_player/views/player/full_screen_player.dart';
import 'package:music_player/views/playlists/playlists_screen.dart';
import 'package:music_player/views/settings/settings_screen.dart';
import 'package:music_player/views/settings/translators_screen.dart';

class NavigationService {
  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal() {
    final routes = [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: _routes(),
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: BottomNavigationScreen(
              body: navigationShell,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: '/player',
        pageBuilder: (context, state) {
          return getPage(
            child: const FullScreenMusicPlayer(),
            state: state,
          );
        },
      ),
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: homePath,
      routes: routes,
    );
  }
  static final NavigationService _instance = NavigationService._internal();

  static NavigationService get instance => _instance;

  static late final GoRouter router;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> favoriteTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  static const String homePath = '/home';
  static const String searchPath = '/search';
  static const String settingsPath = '/settings';
  static const String playlistsPath = '/playlists';
  static const String allSongs = '/all-songs';
  static const String albumSongs = '/album-songs';

  List<StatefulShellBranch> _routes() {
    return [
      StatefulShellBranch(
        navigatorKey: homeTabNavigatorKey,
        routes: [
          GoRoute(
            path: homePath,
            pageBuilder: (context, GoRouterState state) {
              return getPage(
                child: const HomeScreen(),
                state: state,
              );
            },
            routes: [
              GoRoute(
                path: 'all-songs',
                builder: (context, state) => const AllSongsScreen(),
              ),
              GoRoute(
                path: 'album-songs/:albumId',
                builder: (context, state) => AlbumSongsScreen(
                    albumId: int.tryParse(
                          state.pathParameters['albumId']!,
                        ) ??
                        0),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: favoriteTabNavigatorKey,
        routes: [
          GoRoute(
            path: searchPath,
            pageBuilder: (context, GoRouterState state) {
              return getPage(
                child: const PlaylistsScreen(),
                state: state,
              );
            },
            routes: [
              GoRoute(
                name: 'favorites',
                path: 'favorites',
                builder: (context, state) => const FavoriteScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: settingsTabNavigatorKey,
        routes: [
          GoRoute(
            path: settingsPath,
            pageBuilder: (context, state) {
              return getPage(
                child: const SettingsScreen(),
                state: state,
              );
            },
            routes: [
              GoRoute(
                path: 'translators',
                name: 'translators',
                builder: (context, state) => const TranslatorsScreen(),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
