import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/position.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer()
    ..setLoopMode(LoopMode.off)
    ..setAndroidAudioAttributes(
      const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
    );

  final _shuffleNotifier = ValueNotifier<bool>(false);
  final _repeatNotifier = ValueNotifier<bool>(false);

  // Current playlist management
  Map<String, dynamic> _activePlaylist = {'list': []};
  int _activeSongId = 0;

  late final StreamSubscription<PlaybackEvent> _playbackEventSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<int?> _currentIndexSubscription;
  late final StreamSubscription<SequenceState?> _sequenceStateSubscription;

  AudioPlayerHandler() {
    _initialize();
    _setupEventSubscriptions();
    _updatePlaybackState();
  }

  // Getters
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  bool get hasNext => _activePlaylist['list'].isEmpty
      ? _audioPlayer.hasNext
      : _activeSongId + 1 < _activePlaylist['list'].length;

  bool get hasPrevious => _activePlaylist['list'].isEmpty
      ? _audioPlayer.hasPrevious
      : _activeSongId > 0;

  ValueNotifier<bool> get shuffleNotifier => _shuffleNotifier;
  ValueNotifier<bool> get repeatNotifier => _repeatNotifier;

  // Private methods
  Future<void> _initialize() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      _setupAudioInterruptions(session);
    } catch (e) {
      print('Error initializing audio session: $e');
    }
  }

  void _setupAudioInterruptions(AudioSession session) {
    session.interruptionEventStream.listen((event) async {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            await _audioPlayer.setVolume(0.5);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            await _audioPlayer.pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            await _audioPlayer.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            await _audioPlayer.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });
  }

  void _setupEventSubscriptions() {
    _playbackEventSubscription =
        _audioPlayer.playbackEventStream.listen(_handlePlaybackEvent);
    _durationSubscription =
        _audioPlayer.durationStream.listen(_handleDurationChange);
    _currentIndexSubscription =
        _audioPlayer.currentIndexStream.listen(_handleCurrentSongIndexChanged);
    _sequenceStateSubscription =
        _audioPlayer.sequenceStateStream.listen(_handleSequenceStateChange);
  }

  void _handlePlaybackEvent(PlaybackEvent event) {
    if (event.processingState == ProcessingState.completed &&
        _audioPlayer.playing) {
      if (hasNext) {
        skipToNext();
      }
    }
    _updatePlaybackState();
  }

  void _handleDurationChange(Duration? duration) {
    final index = _audioPlayer.currentIndex;
    if (index != null && queue.value.isNotEmpty) {
      final newQueue = List<MediaItem>.from(queue.value);
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    }
  }

  void _handleCurrentSongIndexChanged(int? index) {
    if (index != null && queue.value.isNotEmpty) {
      mediaItem.add(queue.value[index]);
    }
  }

  void _handleSequenceStateChange(SequenceState? sequenceState) {
    final sequence = sequenceState?.effectiveSequence;
    if (sequence != null && sequence.isNotEmpty) {
      final items = sequence.map((source) => source.tag as MediaItem).toList();
      queue.add(items);
      _shuffleNotifier.value = sequenceState?.shuffleModeEnabled ?? false;
    }
  }

  void _updatePlaybackState() {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          _audioPlayer.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _getProcessingState(),
        repeatMode: _getRepeatMode(),
        shuffleMode: _audioPlayer.shuffleModeEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: _audioPlayer.playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: _audioPlayer.currentIndex ?? 0,
      ),
    );
  }

  AudioProcessingState _getProcessingState() {
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  AudioServiceRepeatMode _getRepeatMode() {
    switch (_audioPlayer.loopMode) {
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
    }
  }

  // Public methods
  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() => _audioPlayer.stop();

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToNext() async {
    if (hasNext) {
      await playTrack(_activeSongId + 1);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (hasPrevious) {
      await playTrack(_activeSongId - 1);
    }
  }

  // Add error handling and state logging
  Future<void> playTrack(int index) async {
    try {
      print('${_activePlaylist['list'].length}');
      if (index >= 0 && index < _activePlaylist['list'].length) {
        _activeSongId = _shuffleNotifier.value
            ? _generateRandomIndex(_activePlaylist['list'].length)
            : index;

        final track = _activePlaylist['list'][_activeSongId];
        final file = File(track['_data']);

        if (!await file.exists()) {
          print('File does not exist!');
          return;
        }

        // Try using a progressive audio source
        await _audioPlayer.setAudioSource(
          ProgressiveAudioSource(
            Uri.file(track['_data']),
            tag: _createMediaItem(track),
          ),
        );

        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error playing track: $e');
    }
  }

  MediaItem _createMediaItem(Map<String, dynamic> track) {
    return MediaItem(
      id: '1',
      album: 'test',
      title: 'test',
      artist: null,
      duration: Duration(milliseconds: 0),
      artUri: null,
    );
  }

  Future<void> setPlaylist(
      Map<String, dynamic> playlist, int initialIndex) async {
    _activePlaylist = playlist;
    await playTrack(initialIndex);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode != AudioServiceShuffleMode.none;
    _shuffleNotifier.value = enabled;
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _repeatNotifier.value = repeatMode != AudioServiceRepeatMode.none;
    await _audioPlayer.setLoopMode(
      repeatMode == AudioServiceRepeatMode.one ? LoopMode.one : LoopMode.off,
    );
  }

  int _generateRandomIndex(int length) {
    if (length <= 1) return 0;
    final random = Random();
    var newIndex = random.nextInt(length);
    while (newIndex == _activeSongId) {
      newIndex = random.nextInt(length);
    }
    return newIndex;
  }

  @override
  Future<void> onTaskRemoved() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    await _playbackEventSubscription.cancel();
    await _durationSubscription.cancel();
    await _currentIndexSubscription.cancel();
    await _sequenceStateSubscription.cancel();
    await super.onTaskRemoved();
  }
}
