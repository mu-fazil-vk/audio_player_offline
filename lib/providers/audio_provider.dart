import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/position.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/providers/audio_data_provider.dart';
import 'package:music_player/services/audio_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerHandler _audioHandler;

  bool _isPlaying = false;
  AudioModel? _currentPlayingAudio;
  Map<String, dynamic> _currentPlaylist = {'list': []};
  int _currentTrackIndex = 0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioProvider(this._audioHandler);

  // Getters
  bool get isPlaying => _isPlaying;
  Map<String, dynamic> get currentPlaylist => _currentPlaylist;
  int get currentTrackIndex => _currentTrackIndex;
  Duration get position => _position;
  Duration get duration => _duration;
  Stream<PositionData> get positionDataStream =>
      _audioHandler.positionDataStream;
  ValueNotifier<bool> get shuffleNotifier => _audioHandler.shuffleNotifier;
  ValueNotifier<bool> get repeatNotifier => _audioHandler.repeatNotifier;
  bool get hasNext => _audioHandler.hasNext;
  bool get hasPrevious => _audioHandler.hasPrevious;
  AudioModel? get currentPlayingAudio => _currentPlayingAudio;

  void initialize(BuildContext context) {
  // Debounce variables
  DateTime? _lastPositionUpdate;
  AudioModel? _lastPlayingAudio;
  bool? _lastPlayingState;
  
  // Listen to playback state changes with throttling
  _audioHandler.playbackState
      .distinct() // Only emit when state actually changes
      .listen((state) {
    // Check if state update is needed using local cache
    final bool currentPlaying = state.playing;
    if (_lastPlayingState != currentPlaying) {
      _lastPlayingState = currentPlaying;
      _isPlaying = currentPlaying;
      
      // Handle recently played update
      if (currentPlaying) {
        // Use microtask to avoid blocking the main thread
        Future.microtask(() {
          if (_currentPlayingAudio != null) {
            context
                .read<AudioDataProvider>()
                .addSongToRecentlyPlayed(_currentPlayingAudio!.id);
          }
        });
      }
      
      log('Is Playing: ${_audioHandler.mediaItem.value?.title}');
      notifyListeners();
    }

    // Cache current playlist for faster access
    final List<AudioModel> currentPlayingAudioItems = _currentPlaylist['list'];
    if (currentPlayingAudioItems.isEmpty) return;

    // Optimize audio item lookup
    final String? currentMediaId = _audioHandler.mediaItem.value?.id;
    if (currentMediaId == null) return;

    // Use firstWhere with orElse for more efficient lookup
    AudioModel? newPlayingAudio;
    try {
      newPlayingAudio = currentPlayingAudioItems.toList().firstWhere(
        (element) => element.id.toString() == currentMediaId,
        orElse: () => _currentPlayingAudio!,
      );
    } catch (e) {
      newPlayingAudio = _currentPlayingAudio;
    }

    // Compare with cached value to avoid unnecessary updates
    if (_lastPlayingAudio?.id != newPlayingAudio?.id) {
      _lastPlayingAudio = newPlayingAudio;
      _currentPlayingAudio = newPlayingAudio;
      notifyListeners();
    }
  });

  // Listen to position updates with throttling
  _audioHandler.positionDataStream
      .distinct() // Only emit when position actually changes
      .listen((positionData) {
    final now = DateTime.now();
    
    // Throttle updates to max once per second
    if (_lastPositionUpdate != null &&
        now.difference(_lastPositionUpdate!) < const Duration(milliseconds: 250)) {
      return;
    }

    // Check if update is significant enough
    final positionDifference = (_position - positionData.position).abs();
    final durationChanged = _duration != positionData.duration;
    
    if (positionDifference > const Duration(milliseconds: 500) || durationChanged) {
      _lastPositionUpdate = now;
      _position = positionData.position;
      _duration = positionData.duration;
      notifyListeners();
    }
  });
}


  // Set current playing audio
  void setCurrentPlayingAudio(AudioModel? audio) {
    if (_currentPlayingAudio != audio) {
      _currentPlayingAudio = audio;
      notifyListeners();
    }
  }

  // Playback control methods
  Future<void> play() async => await _audioHandler.play();
  Future<void> pause() async => await _audioHandler.pause();
  Future<void> stop() async => await _audioHandler.stop();
  Future<void> seek(Duration position) async =>
      await _audioHandler.seek(position);
  Future<void> skipToNext() async => await _audioHandler.skipToNext();
  Future<void> skipToPrevious() async => await _audioHandler.skipToPrevious();

  Future<void> toggleShuffle() async {
    final currentMode = shuffleNotifier.value;
    if (repeatNotifier.value) {
      await _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }
    await _audioHandler.setShuffleMode(currentMode
        ? AudioServiceShuffleMode.none
        : AudioServiceShuffleMode.all);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    final currentMode = repeatNotifier.value;
    if (shuffleNotifier.value) {
      await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
    await _audioHandler.setRepeatMode(
        currentMode ? AudioServiceRepeatMode.none : AudioServiceRepeatMode.one);
    notifyListeners();
  }

  Future<void> setPlaylist(
      Map<String, dynamic> playlist, int initialIndex) async {
    _currentPlaylist = playlist;
    _currentTrackIndex = initialIndex;
    _currentPlayingAudio = playlist['list'][initialIndex];
    notifyListeners();
    await _audioHandler.setPlaylist(playlist, initialIndex);
    notifyListeners();
  }

  Future<void> playTrack(int index) async {
    _currentTrackIndex = index;
    await _audioHandler.playTrack(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioHandler.onTaskRemoved();
    super.dispose();
  }
}
