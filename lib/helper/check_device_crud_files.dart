import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<bool> checkChangeOccuredInDeviceSongsFiles() async {
  List<SongModel> deviceSongModelsList = await OnAudioQuery().querySongs();
  deviceSongModelsList = deviceSongModelsList.where((song) {
    return song.isMusic! &&
        !song.displayName.contains("AUD-") &&
        !(song.title == "tone");
  }).toList();
  var databaseMySongModelsList =
      Hive.box<MySongModel>(kMySongModelBox).values.toList();
  if (deviceSongModelsList.length != databaseMySongModelsList.length) {
    return true;
  }
  databaseMySongModelsList.sort(
    (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
  );
  deviceSongModelsList.sort(
    (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
  );
  for (int i = 0; i < databaseMySongModelsList.length; i++) {
    if (deviceSongModelsList[i].displayName !=
        databaseMySongModelsList[i].displayName) {
      return true;
    }
  }
  return false;
}

// Future<bool> checkChangeOccured() async {
//   List<MySongModel> databaseMySongModels =
//       Hive.box<MySongModel>(kMySongModelBox).values.toList();
//   List<SongModel> deviceSongModels = (await OnAudioQuery().querySongs())
//       .where((song) =>
//           song.isMusic! &&
//           !song.displayName.contains("AUD-") &&
//           !(song.title == "tone"))
//       .toList();
//   if (deviceSongModels.length != databaseMySongModels.length) {
//     await handleSongsAdded();
//     await handleSongsRemoved();
//     return false;
//   } else {
//     return true;
//   }
// }
