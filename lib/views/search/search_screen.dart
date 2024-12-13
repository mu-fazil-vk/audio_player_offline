import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/widgets/search/custom_tile_with_highlight.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:tuple/tuple.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _filteredItems = [];
  String _searchQuery = '';
  Timer? _debounceTimer;

  // Debounce duration - adjust this value as needed
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _filteredItems = context.read<AudioDataProvider>().allSongs;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();

    // Start a new timer
    _debounceTimer = Timer(_debounceDuration, () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
          _filterItems();
        });
      }
    });
  }

  void _filterItems() {
    final allSongs = context.read<AudioDataProvider>().allSongs;

    if (_searchQuery.isEmpty) {
      _filteredItems = allSongs;
    } else {
      _filteredItems = allSongs
          .where((item) =>
              item.title.toString().toLowerCase().contains(_searchQuery) ||
              item.artist.toString().toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.search.tr()),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
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
                  hintText: '${LocaleKeys.search.tr()}...',
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
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      key: ValueKey(_searchQuery),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final AudioModel item = _filteredItems[index];

        return Selector2<AudioDataProvider, AudioProvider, Tuple2<bool, bool>>(
          selector: (context, audioDataProvider, audioProvider) {
            final isFavorite = audioDataProvider.likedSongs.contains(item);
            final isPlaying = audioProvider.currentPlayingAudio == item;
            return Tuple2(isFavorite, isPlaying);
          },
          builder: (context, state, child) {
            return CustomAudioListTileWithHighlight(
              audioInfo: item,
              showDuration: true,
              searchQuery: _searchQuery,
              isFavorite: state.item1,
              isPlaying: state.item2,
              onTap: () {
                context.read<AudioProvider>().setPlaylist({
                  'type': 'audio',
                  'list': _filteredItems,
                }, index);
                context.push('/player');
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.startTyping.tr(),
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
            LocaleKeys.noResultsFound
                .tr(namedArgs: {'query': _searchController.text}),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}
