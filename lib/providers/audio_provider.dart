import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/models/position.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/services/audio_handler.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerHandler _audioHandler;

  bool _isPlaying = false;
  AudioModel? _currentPlayingAudio;
  Map<String, dynamic> _currentPlaylist = {'list': []};
  int _currentTrackIndex = 0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioProvider(this._audioHandler) {
    _initialize();
  }

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

  void _initialize() {
    // Listen to playback state changes
    _audioHandler.playbackState.listen((state) {
      _isPlaying = state.playing;
      log('Is Playing: ${_audioHandler.mediaItem.value?.title}');
      final currentPlayingAudioItems =
          _currentPlaylist['list'];
      if (currentPlayingAudioItems.isNotEmpty) {
        final filteredItems = currentPlayingAudioItems.where((element) {
          return element?.id.toString() == _audioHandler.mediaItem.value?.id;
        }).toList();

        if (filteredItems.isNotEmpty) {
          _currentPlayingAudio = filteredItems.first;
        } else {
          _currentPlayingAudio = _currentPlayingAudio;
        }
      }
      notifyListeners();
    });

    // Listen to current position
    _audioHandler.positionDataStream.listen((positionData) {
      _position = positionData.position;
      _duration = positionData.duration;
      notifyListeners();
    });
  }

  // Set current playing audio
  void setCurrentPlayingAudio(AudioModel audio) {
    _currentPlayingAudio = audio;
    notifyListeners();
  }

  // Playback control methods
  Future<void> play() async {
    await _audioHandler.play();
  }

  Future<void> pause() async {
    await _audioHandler.pause();
  }

  Future<void> stop() async {
    await _audioHandler.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioHandler.seek(position);
  }

  Future<void> skipToNext() async {
    await _audioHandler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _audioHandler.skipToPrevious();
  }

  Future<void> toggleShuffle() async {
    final currentMode = shuffleNotifier.value;
    if (repeatNotifier.value) {
      await _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }
    await _audioHandler.setShuffleMode(
      currentMode ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all,
    );
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    final currentMode = repeatNotifier.value;
    if (shuffleNotifier.value) {
      await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
    await _audioHandler.setRepeatMode(
      currentMode ? AudioServiceRepeatMode.none : AudioServiceRepeatMode.one,
    );
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
