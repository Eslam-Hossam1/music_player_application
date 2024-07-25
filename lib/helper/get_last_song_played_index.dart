import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_song_model.dart';

int getLastSongPlayedIndex(List<MySongModel> songModelList) {
  var songId = Hive.box<int>(kLastSongIdPlayedBox).get(kLastSongIdPlayedKey);
  for (int i = 0; i < songModelList.length; i++) {
    if (songId == songModelList[i].id) {
      return i;
    }
  }
  return 0;
}
