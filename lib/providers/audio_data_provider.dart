import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../services/audio_data_service.dart';

class AudioDataProvider extends ChangeNotifier {
  // Singleton instance
  static AudioDataProvider? _instance;
  final AudioDataService _audioDataService;
  final Box _userBox = Hive.box('user');

  // Private data fields
  List _customPlaylists = [];
  List _likedSongs = [];
  List _recentlyPlayed = [];
  List _allSongs = [];
  
  // Private constructor
  AudioDataProvider._({required AudioDataService audioDataService})
      : _audioDataService = audioDataService {
    _loadInitialData();
  }
  
  // Factory constructor for singleton instance
  factory AudioDataProvider({required AudioDataService audioDataService}) {
    _instance ??= AudioDataProvider._(audioDataService: audioDataService);
    return _instance!;
  }

  // Getters
  List get customPlaylists => _customPlaylists;
  List get likedSongs => _likedSongs;
  List get recentlyPlayed => _recentlyPlayed;
  List get recentlyPlayedSongModels => _recentlyPlayed
      .map((e) => _allSongs.firstWhere((song) => song.id == e['id']))
      .toList();
  List get allSongs => _allSongs;

  void _loadInitialData() async {
    if (_customPlaylists.isEmpty) {
      _customPlaylists = _userBox.get('customPlaylists', defaultValue: []);
      _likedSongs = _userBox.get('likedSongs', defaultValue: []);
      _recentlyPlayed = _userBox.get('recentlyPlayedSongs', defaultValue: []);
      await getAllSongs();
      notifyListeners();
    }
  }

  void updateFromDb() {
    _loadInitialData();
    notifyListeners();
  }

  // Cache for getAllSongs results
  List<AudioModel>? _cachedSongs;
  DateTime? _lastSongsFetch;
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  Future<(Exception?, List<AudioModel>?)> getAllSongs() async {
    // Check if cache is valid
    if (_cachedSongs != null && _lastSongsFetch != null) {
      final difference = DateTime.now().difference(_lastSongsFetch!);
      if (difference < _cacheValidityDuration) {
        return (null, _cachedSongs);
      }
    }

    return await _audioDataService.getAllSongs().then((value) {
      if (value.$2 != null) {
        final songs = value.$2!.map((e) => AudioModel.fromTheirSongModel(e)).toList();
        _allSongs = songs;
        // Update cache
        _cachedSongs = songs;
        _lastSongsFetch = DateTime.now();
        return (null, songs);
      } else {
        return (Exception('Error'), null);
      }
    });
  }

  // Cache for albums
  Map<int, List<AudioModel>> _albumSongsCache = {};
  List<AlbumModel>? _cachedAlbums;
  DateTime? _lastAlbumsFetch;

  Future<(Exception?, List<AlbumModel>?)> getAllAlbumsList() async {
    // Check if cache is valid
    if (_cachedAlbums != null && _lastAlbumsFetch != null) {
      final difference = DateTime.now().difference(_lastAlbumsFetch!);
      if (difference < _cacheValidityDuration) {
        return (null, _cachedAlbums);
      }
    }

    return await _audioDataService.getAllAlbumsList().then((value) {
      if (value.$2 != null) {
        _cachedAlbums = value.$2!.toList();
        _lastAlbumsFetch = DateTime.now();
        return (null, _cachedAlbums);
      } else {
        return (Exception('Error'), null);
      }
    });
  }

  Future<(Exception?, List<AudioModel>?)> getAlbumsList(int albumId) async {
    // Check cache first
    if (_albumSongsCache.containsKey(albumId)) {
      return (null, _albumSongsCache[albumId]);
    }

    return await _audioDataService.getAlbumsList(albumId).then((value) {
      if (value.$2 != null) {
        final songs = value.$2!.map((e) => AudioModel.fromTheirSongModel(e)).toList();
        // Cache the results
        _albumSongsCache[albumId] = songs;
        return (null, songs);
      } else {
        return (Exception('Error'), null);
      }
    });
  }

  Future<List> getSongsList(String query) async {
    if (query.isEmpty) {
      return _allSongs;
    }
    
    final queryLower = query.toLowerCase();
    return _allSongs.where((song) =>
      song.title.toLowerCase().contains(queryLower) ||
      song.artist.toLowerCase().contains(queryLower)
    ).toList();
  }

  Future<void> getUserPlaylists() async {
    await _audioDataService.getUserPlaylists();
  }

  String createCustomPlaylist(String playlistName, String? image) {
    final customPlaylist = {
      'title': playlistName,
      'source': 'user-created',
      if (image != null) 'image': image,
      'list': [],
    };

    _customPlaylists.add(customPlaylist);
    _updateStorage('customPlaylists', _customPlaylists);
    notifyListeners();
    return 'Playlist created successfully!';
  }

  void toggleSongLike(String songId, bool isLiked) {
    if (isLiked && !_likedSongs.any((song) => song['id'] == songId)) {
      _likedSongs.add({'id': songId});
    } else {
      _likedSongs.removeWhere((song) => song['id'] == songId);
    }
    _updateStorage('likedSongs', _likedSongs);
    notifyListeners();
  }

  void addSongToRecentlyPlayed(int songId) {
    if (!_recentlyPlayed.any((song) => song['id'] == songId)) {
      _recentlyPlayed.add({'id': songId});
      _updateStorage('recentlyPlayedSongs', _recentlyPlayed);
      notifyListeners();
    }
  }

  void _updateStorage(String key, dynamic value) {
    _userBox.put(key, value);
  }

  // Method to clear caches if needed
  void clearCaches() {
    _cachedSongs = null;
    _lastSongsFetch = null;
    _cachedAlbums = null;
    _lastAlbumsFetch = null;
    _albumSongsCache.clear();
  }
}