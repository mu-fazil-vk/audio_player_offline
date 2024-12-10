// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CustomPlaylistModel {
  final String id;
  final String name;
  final String? image;
  final List<String> songs;
  CustomPlaylistModel({
    required this.id,
    required this.name,
    this.image,
    required this.songs,
  });

  CustomPlaylistModel copyWith({
    String? id,
    String? name,
    String? image,
    List<String>? songs,
  }) {
    return CustomPlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      songs: songs ?? this.songs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'songs': songs,
    };
  }

  factory CustomPlaylistModel.fromMap(Map<dynamic, dynamic> map) {
    return CustomPlaylistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String?,
      songs: map['songs'] as List<String>,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomPlaylistModel.fromJson(String source) =>
      CustomPlaylistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistModel(id: $id, name: $name, image: $image, songs: $songs)';
  }

  @override
  bool operator ==(covariant CustomPlaylistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.image == image &&
        listEquals(other.songs, songs);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ image.hashCode ^ songs.hashCode;
  }
}
