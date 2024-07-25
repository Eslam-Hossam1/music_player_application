import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';

void filterDatabaseModelList(MyPlaylistModel playlistModel) {
  List<MySongModel> songModelList =
      Hive.box<MySongModel>(kMySongModelBox).values.toList();
  for (int i = 0; i < playlistModel.mysongModelsIdList.length; i++) {
    bool isFound = false;
    for (int j = 0; j < songModelList.length; j++) {
      if (songModelList[j].id == playlistModel.mysongModelsIdList[i]) {
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      playlistModel.mysongModelsIdList.removeAt(i);
    }
  }
  playlistModel.save();
}
