import 'dart:developer';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AudioDataService {
  Future<(Exception?, List<SongModel>?)> getAllSongs();
  Future<(Exception?, List<AlbumModel>?)> getAllAlbumsList();
  Future<(Exception?, List<SongModel>?)> getAlbumsList(int albumId);
  Future<void> getUserPlaylists();
}

class AudioDataServiceImpl implements AudioDataService {
  static final AudioDataServiceImpl _instance =
      AudioDataServiceImpl._internal();

  factory AudioDataServiceImpl() => _instance;

  AudioDataServiceImpl._internal();

  @override
  Future<(Exception?, List<SongModel>?)> getAllSongs() async {
    try {
      // Check permissions
      var storageStatus = await Permission.storage.status;
      var audioStatus = await Permission.audio.status;
      var mediaStatus = await Permission.mediaLibrary.status;

      if (!storageStatus.isGranted &&
          (!audioStatus.isGranted || !mediaStatus.isGranted)) {
        return (Exception('Permission denied'), null);
      }

      // Fetch all songs from Storage.
      OnAudioQuery audioQuery = OnAudioQuery();
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      log('Songs: $songs');
      return (null, songs);
    } catch (e, stackTrace) {
      log('Error in fetchAllSongs \n$e\n\n$stackTrace');
      return (Exception('Error'), null);
    }
  }

  @override
  Future<(Exception?, List<AlbumModel>?)> getAllAlbumsList() async {
    try {
      var storageStatus = await Permission.storage.status;
      var audioStatus = await Permission.audio.status;
      var mediaStatus = await Permission.mediaLibrary.status;

      if (!storageStatus.isGranted &&
          (!audioStatus.isGranted || !mediaStatus.isGranted)) {
        return (Exception('Permission denied'), null);
      }
      // Fetch albums from Storage.
      OnAudioQuery audioQuery = OnAudioQuery();
      final albums = await audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      log('Albums: $albums');
      return (null, albums);
    } catch (e, stackTrace) {
      log('Error in fetchAlbumsList \n$e\n\n$stackTrace');
      return (Exception('Error'), null);
    }
  }

  @override
  Future<(Exception?, List<SongModel>?)> getAlbumsList(int albumId) async {
    try {
      var storageStatus = await Permission.storage.status;
      var audioStatus = await Permission.audio.status;
      var mediaStatus = await Permission.mediaLibrary.status;

      if (!storageStatus.isGranted &&
          (!audioStatus.isGranted || !mediaStatus.isGranted)) {
        return (Exception('Permission denied'), null);
      }
      // Fetch albums from Storage.
      OnAudioQuery audioQuery = OnAudioQuery();
      // fetch songs from album id
      final albums = await audioQuery.queryAudiosFrom(
        AudiosFromType.ALBUM_ID,
        albumId,
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
      );
      log('Albums: $albums');
      return (null, albums);
    } catch (e, stackTrace) {
      log('Error in fetchAlbumsList \n$e\n\n$stackTrace');
      return (Exception('Error'), null);
    }
  }

  @override
  Future<List> getUserPlaylists() async {
    try {
      // Fetch user playlists from Storage.
      return [];
    } catch (e, stackTrace) {
      log('Error in fetchUserPlaylists \n$e\n\n$stackTrace');
      return [];
    }
  }
}
