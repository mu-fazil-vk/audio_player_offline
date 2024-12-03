import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../services/audio_data_service.dart';

class AudioDataProvider extends ChangeNotifier {
  final AudioDataService _audioDataService;
  final Box _userBox = Hive.box('user');

  List _customPlaylists = [];
  List _likedSongs = [];
  List _recentlyPlayed = [];
  int _activeSongId = 0;

  AudioDataProvider({required AudioDataService audioDataService})
      : _audioDataService = audioDataService {
    _loadInitialData();
  }

  // Getters
  List get customPlaylists => _customPlaylists;
  List get likedSongs => _likedSongs;
  List get recentlyPlayed => _recentlyPlayed;
  int get activeSongId => _activeSongId;

  void _loadInitialData() {
    _customPlaylists = _userBox.get('customPlaylists', defaultValue: []);
    _likedSongs = _userBox.get('likedSongs', defaultValue: []);
    _recentlyPlayed = _userBox.get('recentlyPlayedSongs', defaultValue: []);
    notifyListeners();
  }

  void updateFromDb() {
    _loadInitialData();
    notifyListeners();
  }

  // Using service for data fetching
  Future<(Exception?, List<SongModel>?)> getAllSongs() async {
    return await _audioDataService.getAllSongs();
  }

  Future<List> getSongsList(String query) async {
    return await _audioDataService.getSongsList(query);
  }

  Future<(Exception?, List<AlbumModel>?)> getAllAlbumsList() async {
    return await _audioDataService.getAllAlbumsList();
  }

  Future<(Exception?, List<AlbumModel>?)> getAlbumsList(String query) async {
    return await _audioDataService.getAlbumsList(query);
  }

  Future<void> getUserPlaylists() async {
    await _audioDataService.getUserPlaylists();
  }

  // State management functions
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
    if (isLiked) {
      // Add to liked songs
      if (!_likedSongs.any((song) => song['id'] == songId)) {
        _likedSongs.add({'id': songId});
      }
    } else {
      // Remove from liked songs
      _likedSongs.removeWhere((song) => song['id'] == songId);
    }
    _updateStorage('likedSongs', _likedSongs);
    notifyListeners();
  }

  // Storage helper
  void _updateStorage(String key, dynamic value) {
    _userBox.put(key, value);
  }
}
