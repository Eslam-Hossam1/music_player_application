import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

part 'my_song_model.g.dart';

@HiveType(typeId: 0)
class MySongModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String data;

  @HiveField(2)
  final String? uri;

  @HiveField(3)
  final String displayName;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String? artist;

  @HiveField(6)
  final String? album;

  @HiveField(7)
  final int? dateAdded;

  @HiveField(8)
  bool isFavourate;

  @HiveField(9)
  final String? artworkUri;

  @HiveField(10)
  final PaletteColorHive primaryPaletteColor;

  @HiveField(11)
  final PaletteColorHive secondaryPaletteColor;

  MySongModel({
    required this.id,
    required this.data,
    this.uri,
    required this.displayName,
    required this.title,
    this.artist,
    this.album,
    this.artworkUri,
    this.dateAdded,
    this.isFavourate = false,
    required this.primaryPaletteColor,
    required this.secondaryPaletteColor,
  });

  factory MySongModel.fromSongModel(SongModel songModel, String? artworkUri,
      PaletteColor primaryPaletteColor, PaletteColor secondaryPaletteColor) {
    return MySongModel(
      id: songModel.id,
      data: songModel.data,
      uri: songModel.uri,
      displayName: songModel.displayName,
      title: songModel.title,
      artist: songModel.artist,
      album: songModel.album,
      dateAdded: songModel.dateAdded ?? 1000000000,
      isFavourate: false,
      artworkUri: artworkUri,
      primaryPaletteColor:
          PaletteColorHive.fromPaletteColor(primaryPaletteColor),
      secondaryPaletteColor:
          PaletteColorHive.fromPaletteColor(secondaryPaletteColor),
    );
  }

  SongModel toSongModel() {
    return SongModel({
      "_id": id,
      "_data": data,
      "_uri": uri,
      "_displayName": displayName,
      "title": title,
      "artist": artist,
      "date_added": dateAdded ?? 100000000,
      "album": album,
    });
  }
}

@HiveType(typeId: 1)
class PaletteColorHive {
  @HiveField(0)
  final int colorValue;

  @HiveField(1)
  final int population;

  @HiveField(2)
  final int bodyTextColorValue;

  @HiveField(3)
  final int titleTextColorValue;

  PaletteColorHive({
    required this.colorValue,
    required this.population,
    required this.bodyTextColorValue,
    required this.titleTextColorValue,
  });

  factory PaletteColorHive.fromPaletteColor(PaletteColor paletteColor) {
    return PaletteColorHive(
      colorValue: paletteColor.color.value,
      population: paletteColor.population,
      bodyTextColorValue: paletteColor.bodyTextColor.value,
      titleTextColorValue: paletteColor.titleTextColor.value,
    );
  }

  PaletteColor toPaletteColor() {
    return PaletteColor(
      Color(colorValue),
      population,
    );
  }
}
