import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';

Future<void> handleSongsAdded() async {
  List<SongModel> toAddSongModels = [];

  var mySongModelbox = Hive.box<MySongModel>(kMySongModelBox);

  List<MySongModel> databaseSongModels =
      Hive.box<MySongModel>(kMySongModelBox).values.toList();

  List<SongModel> deviceSongModels = (await OnAudioQuery().querySongs())
      .where((song) =>
          song.isMusic! &&
          !song.displayName.contains("AUD-") &&
          !(song.title == "tone"))
      .toList();

  for (int i = 0; i < deviceSongModels.length; i++) {
    bool isFound = false;
    for (int j = 0; j < databaseSongModels.length; j++) {
      if (deviceSongModels[i].id == databaseSongModels[j].id) {
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      toAddSongModels.add(deviceSongModels[i]);
    }
  }

  final mySongModels = await Future.wait(toAddSongModels.map((songModel) async {
    final artwork =
        await OnAudioQuery().queryArtwork(songModel.id, ArtworkType.AUDIO);

    String? artworkUri;
    if (artwork != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/${songModel.id}.png')
          .writeAsBytes(artwork);
      artworkUri = file.uri.toString();
    }
    ImageProvider? artworkImageProvider = artwork != null
        ? MemoryImage(artwork)
        : const AssetImage(kApplicationIMage);

    final pg = await PaletteGenerator.fromImageProvider(artworkImageProvider!);

    // Try to get a vibrant or muted color before defaulting to purple
    final primaryPaletteColor = pg.darkVibrantColor ??
        pg.darkMutedColor ??
        pg.vibrantColor ??
        PaletteColor(Colors.black, 2);
    final secondaryPaletteColor = pg.lightMutedColor ??
        pg.lightVibrantColor ??
        PaletteColor(Colors.white, 2);

    return MySongModel.fromSongModel(songModel, artworkUri, primaryPaletteColor,
        secondaryPaletteColor, artwork);
  }));

  await mySongModelbox.addAll(mySongModels);

  await Hive.box(kFlagBox).put(kOpenedBeforeKey, true);
}

Future<void> handleSongsRemoved() async {
  List<MySongModel> toDeleteSongModels = [];

  List<MySongModel> databaseSongModels =
      Hive.box<MySongModel>(kMySongModelBox).values.toList();

  List<SongModel> deviceSongModels = (await OnAudioQuery().querySongs())
      .where((song) =>
          song.isMusic! &&
          !song.displayName.contains("AUD-") &&
          !(song.title == "tone"))
      .toList();

  for (int i = 0; i < databaseSongModels.length; i++) {
    bool isFound = false;
    for (int j = 0; j < deviceSongModels.length; j++) {
      if (deviceSongModels[j].id == databaseSongModels[i].id) {
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      toDeleteSongModels.add(databaseSongModels[i]);
    }
  }

  for (var mySongModel in toDeleteSongModels) {
    log(mySongModel.title);
    await mySongModel.delete();
  }

  await Hive.box(kFlagBox).put(kOpenedBeforeKey, true);
}
