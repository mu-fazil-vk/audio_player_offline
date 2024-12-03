import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/models/position.dart';
import 'package:music_player/services/audio_handler.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerHandler _audioHandler;
  
  bool _isPlaying = false;
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
  Stream<PositionData> get positionDataStream => _audioHandler.positionDataStream;
  ValueNotifier<bool> get shuffleNotifier => _audioHandler.shuffleNotifier;
  ValueNotifier<bool> get repeatNotifier => _audioHandler.repeatNotifier;
  bool get hasNext => _audioHandler.hasNext;
  bool get hasPrevious => _audioHandler.hasPrevious;

  void _initialize() {
    // Listen to playback state changes
    _audioHandler.playbackState.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Listen to current position
    _audioHandler.positionDataStream.listen((positionData) {
      _position = positionData.position;
      _duration = positionData.duration;
      notifyListeners();
    });
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
    final currentMode = _audioHandler.shuffleNotifier.value;
    await _audioHandler.setShuffleMode(
      currentMode
          ? AudioServiceShuffleMode.none
          : AudioServiceShuffleMode.all,
    );
  }

  Future<void> toggleRepeat() async {
    final currentMode = _audioHandler.repeatNotifier.value;
    await _audioHandler.setRepeatMode(
      currentMode
          ? AudioServiceRepeatMode.none
          : AudioServiceRepeatMode.all,
    );
  }

  Future<void> setPlaylist(Map<String, dynamic> playlist, int initialIndex) async {
    _currentPlaylist = playlist;
    _currentTrackIndex = initialIndex;
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