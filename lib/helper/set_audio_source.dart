import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/models/my_song_model.dart';

Future<void> setupAudioPlayer(
    {required List<MySongModel> mySongModelList,
    required AudioPlayer audioPlayer}) async {
  List<AudioSource> audioSourceList = [];
  for (var mySongModel in mySongModelList) {
    audioSourceList.add(AudioSource.uri(Uri.parse(mySongModel.uri!),
        tag: MediaItem(
          id: mySongModel.id.toString(),
          album: mySongModel.album,
          title: mySongModel.title,
          artUri: mySongModel.artworkUri != null
              ? Uri.parse(mySongModel.artworkUri!)
              : null,
        )));
  }
  await audioPlayer
      .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
}
