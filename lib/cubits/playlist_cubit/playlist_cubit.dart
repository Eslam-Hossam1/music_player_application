import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_state.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';

class PlaylistCubit extends Cubit<PlaylistStates> {
  PlaylistCubit() : super(PlaylistInitialState());
  final _playlistBox = Hive.box<MyPlaylistModel>(kMyPlaylistModelBox);
  List<MyPlaylistModel> myPlaylistModelsList = [];
  AudioPlayer audioPlayer = AudioPlayer();

  void fetchPlayLists() {
    emit(PlaylistLoadingState());
    try {
      myPlaylistModelsList = _playlistBox.values.toList();
      emit(PlaylistSuccessState());
    } catch (e) {
      emit(PlaylistFailureState(errMsg: e.toString()));
    }
  }

  Future<void> setupAudioPlayer(List<MySongModel> mySongModelList) async {
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
    try {
      await audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
    } on PlayerException {
      audioPlayer.stop();
    }
  }
}
