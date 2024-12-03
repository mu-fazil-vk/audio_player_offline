import 'package:music_player/services/audio_handler.dart';

import 'package:audio_service/audio_service.dart';

class OfflineAudioService {
  // Private constructor
  OfflineAudioService._();

  // Singleton instance
  static final OfflineAudioService _instance = OfflineAudioService._();

  // Factory constructor to return the singleton instance
  factory OfflineAudioService() => _instance;

  // Getter for the singleton instance
  static OfflineAudioService get instance => _instance;

  late AudioPlayerHandler _audioHandler;
  bool _isInitialized = false;

  // Getter for the audio handler
  AudioPlayerHandler get audioHandler {
    if (!_isInitialized) {
      throw StateError('OfflineAudioService must be initialized before use');
    }
    return _audioHandler;
  }

  // Initialization method
  Future<void> initialize() async {
    if (_isInitialized) {
      print('OfflineAudioService already initialized');
      return;
    }

    try {
      _audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.music_player',
          androidNotificationChannelName: 'Audio Service',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize OfflineAudioService: $e');
      rethrow;
    }
  }

// Check if service is initialized
  bool get isInitialized => _isInitialized;

  // Dispose method
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      await _audioHandler.onTaskRemoved();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing OfflineAudioService: $e');
      rethrow;
    }
  }
}
