// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

/// [AudioModel] that contains all [Song] Information.
class AudioModel {
  AudioModel(
    this._info,
  );

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  final Map<dynamic, dynamic> _info;

  /// Return song [id]
  int get id => _info["_id"];

  /// Return song [data]
  String get data => _info["_data"];

  /// Return song [uri]
  String? get uri => _info["_uri"];

  /// Return song [displayName]
  String get displayName => _info["_display_name"];

  /// Return song [displayName] without Extension
  String get displayNameWOExt => _info["_display_name_wo_ext"];

  /// Return song [size]
  int get size => _info["_size"];

  /// Return song [album]
  String? get album => _info["album"];

  /// Return song [albumId]
  int? get albumId => _info["album_id"];

  /// Return song [artist]
  String? get artist => _info["artist"];

  /// Return song [artistId]
  int? get artistId => _info["artist_id"];

  /// Return song [genre]
  ///
  /// Important:
  ///   * Only Api >= 30/Android 11
  String? get genre => _info["genre"];

  /// Return song [genreId]
  ///
  /// Important:
  ///   * Only Api >= 30/Android 11
  int? get genreId => _info["genre_id"];

  /// Return song [bookmark]
  int? get bookmark => _info["bookmark"];

  /// Return song [composer]
  String? get composer => _info["composer"];

  /// Return song [dateAdded]
  int? get dateAdded => _info["date_added"];

  /// Return song [dateModified]
  int? get dateModified => _info["date_modified"];

  /// Return song [duration]
  int? get duration => _info["duration"];

  /// Return song [title]
  String get title => _info["title"];

  /// Return song [track]
  int? get track => _info["track"];

  /// Return song only the [fileExtension]
  String get fileExtension => _info["file_extension"];

  // Bool methods

  /// Return song type: [isAlarm]
  ///
  /// Will always return true or false
  bool? get isAlarm => _info["is_alarm"];

  /// Return song type: [isAudioBook]
  ///
  /// Will always return true or false
  ///
  /// Important:
  ///   * Only Api >= 29/Android 10
  bool? get isAudioBook => _info["is_audiobook"];

  /// Return song type: [isMusic]
  ///
  /// Will always return true or false
  bool? get isMusic => _info["is_music"];

  /// Return song type: [isNotification]
  ///
  /// Will always return true or false
  bool? get isNotification => _info["is_notification"];

  /// Return song type: [isPodcast]
  ///
  /// Will always return true or false
  bool? get isPodcast => _info["is_podcast"];

  /// Return song type: [isRingtone]
  ///
  /// Will always return true or false
  bool? get isRingtone => _info["is_ringtone"];

  /// Return a map with all [keys] and [values] from specific song.
  Map get getMap => _info;

  @override
  String toString() => 'SongModel(_info: $_info)';

  AudioModel copyWith({
    Map<dynamic, dynamic>? info,
  }) {
    return AudioModel(
      info ?? this._info,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_info': _info,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      Map<dynamic, dynamic>.from((map['_info'] as Map<dynamic, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioModel.fromJson(String source) =>
      AudioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AudioModel.fromMediaItem(Map<String, dynamic> map) {
    return AudioModel(
      {
        "_id": map["id"],
        "_data": map["artUri"],
        "_uri": map["artUri"],
        "_display_name": map["displayTitle"],
        "_display_name_wo_ext": map["displayTitle"],
        "_size": 0,
        "album": map["album"],
        "album_id": 0,
        "artist": map["artist"],
        "artist_id": 0,
        "genre": map["genre"],
        "genre_id": 0,
        "bookmark": 0,
        "composer": "",
        "date_added": 0,
        "date_modified": 0,
        "duration": map["duration"],
        "title": map["title"],
        "track": 0,
        "file_extension": "",
        "is_alarm": false,
        "is_audiobook": false,
        "is_music": true,
        "is_notification": false,
        "is_podcast": false,
        "is_ringtone": false,
      },
    );
  }

  /// Factory constructor to create your SongModel from their SongModel
  factory AudioModel.fromTheirSongModel(dynamic theirSongModel) {
    return AudioModel({
      "_id": theirSongModel.id,
      "_data": theirSongModel.data,
      "_uri": theirSongModel.uri,
      "_display_name": theirSongModel.displayName,
      "_display_name_wo_ext": theirSongModel.displayNameWOExt,
      "_size": theirSongModel.size,
      "album": theirSongModel.album,
      "album_id": theirSongModel.albumId,
      "artist": theirSongModel.artist,
      "artist_id": theirSongModel.artistId,
      "genre": theirSongModel.genre,
      "genre_id": theirSongModel.genreId,
      "bookmark": theirSongModel.bookmark,
      "composer": theirSongModel.composer,
      "date_added": theirSongModel.dateAdded,
      "date_modified": theirSongModel.dateModified,
      "duration": theirSongModel.duration,
      "title": theirSongModel.title,
      "track": theirSongModel.track,
      "file_extension": theirSongModel.fileExtension,
      "is_alarm": theirSongModel.isAlarm,
      "is_audiobook": theirSongModel.isAudioBook,
      "is_music": theirSongModel.isMusic,
      "is_notification": theirSongModel.isNotification,
      "is_podcast": theirSongModel.isPodcast,
      "is_ringtone": theirSongModel.isRingtone,
    });
  }

  @override
  bool operator ==(covariant AudioModel other) {
    if (identical(this, other)) return true;

    return mapEquals(other._info, _info);
  }

  @override
  int get hashCode => _info.hashCode;
}
