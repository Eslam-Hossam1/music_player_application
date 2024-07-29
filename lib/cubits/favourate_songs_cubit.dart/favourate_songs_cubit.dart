import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_states.dart';
import 'package:music_player_app/models/my_reference_bool.dart';
import 'package:music_player_app/models/my_song_model.dart';

class FavourateSongsCubit extends Cubit<FavourateSongsStates> {
  AudioPlayer audioPlayer = AudioPlayer();
  MyReferenceBool referenceBool = MyReferenceBool();

  FavourateSongsCubit() : super(FavourateSongsInitialState()) {
    audioPlayer.setLoopMode(LoopMode.all);
  }

  void addToFavourates({required MySongModel mySongModel}) {
    mySongModel.isFavourate = true;
    mySongModel.save();
    emit(ChangeOccuredState());
  }

  void listenToSongIndex({required AudioPlayer audioplayer}) {
    int x = 1;
    audioplayer.currentIndexStream.listen(
      (event) {
        if (x > 1) {
          emit(FavourateSongsPlayListChangeCurrentIndex(
              cubitCurrentIndex: event ?? 0));
        } else {
          x++;
        }
      },
    );
  }

  void resetFavourateListAndStopAudio() {
    this.referenceBool.isAudioSetted = false;
    this.audioPlayer.stop();
    emit(FavourateSongsPlayListStopCurrentIndex(cubitCurrentIndex: -1));
  }

  void removeFromFavourates({required MySongModel mySongModel}) {
    mySongModel.isFavourate = false;
    mySongModel.save();
    emit(ChangeOccuredState());
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
