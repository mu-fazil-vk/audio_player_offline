import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/common/custom_audio_list_tile.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;
  bool _isSearching = false;

  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Initialize data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<AudioDataProvider>();
        provider.updateFromDb();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
      }
    });
  }

  List _getFilteredItems(List<dynamic> likedSongIds, List<dynamic> allSongs) {
    // Create a map for O(1) lookup
    final songMap = {for (var song in allSongs) song.id.toString(): song};

    // Get all liked songs
    final likedSongs = likedSongIds
        .map((id) => songMap[id])
        .where((song) => song != null)
        .toList();

    if (_searchQuery.isEmpty) {
      return likedSongs;
    } else {
      return likedSongs
          .where((item) =>
              item.title.toString().toLowerCase().contains(_searchQuery) ||
              item.artist.toString().toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search favorites...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    if (!isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No favorite songs yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "${_searchController.text}"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return Consumer<AudioDataProvider>(
      builder: (context, audioDataProvider, child) {
        final filteredItems = _getFilteredItems(
          audioDataProvider.likedSongs,
          audioDataProvider.allSongs,
        );

        if (filteredItems.isEmpty) {
          return _buildEmptyState(_searchQuery.isNotEmpty);
        }

        return ListView.builder(
          key: ValueKey(_searchQuery),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final audioInfo = filteredItems[index];

            return Selector2<AudioDataProvider, AudioProvider,
                Tuple2<bool, bool>>(
              selector: (context, audioDataProvider, audioProvider) {
                final isFavorite = audioDataProvider.likedSongs
                    .contains(audioInfo.id.toString());
                final isPlaying =
                    audioProvider.currentPlayingAudio == audioInfo;
                return Tuple2(isFavorite, isPlaying);
              },
              builder: (context, state, child) {
                return CustomAudioListTile(
                  showDuration: true,
                  audioInfo: audioInfo,
                  onTap: () {
                    context.read<AudioProvider>().setPlaylist({
                      'type': 'audio',
                      'list': filteredItems,
                    }, index);
                    context.push('/player');
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppInfo().appName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching) _buildSearchBar(),
          Expanded(child: _buildSongList()),
        ],
      ),
    );
  }
}
