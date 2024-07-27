import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_song_model.dart';

MySongModel? getMySongModelFromId(int id) {
  List<MySongModel> songModelList =
      Hive.box<MySongModel>(kMySongModelBox).values.toList();
  for (var song in songModelList) {
    if (song.id == id) {
      return song;
    }
  }
  return null;
}
