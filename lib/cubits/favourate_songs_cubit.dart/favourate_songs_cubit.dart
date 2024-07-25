import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_states.dart';
import 'package:music_player_app/models/my_song_model.dart';

class FavourateSongsCubit extends Cubit<FavourateSongsStates> {
  FavourateSongsCubit() : super(FavourateSongsInitialState());
  AudioPlayer audioPlayer = AudioPlayer();
  void addToFavourates({required MySongModel mySongModel}) {
    mySongModel.isFavourate = true;
    mySongModel.save();
    emit(ChangeOccuredState());
  }

  void listenToSongIndex({required AudioPlayer audioplayer}) {
    audioplayer.currentIndexStream.listen(
      (event) {
        emit(FavourateSongsPlayListChangeCurrentIndex(
            cubitCurrentIndex: event ?? 0));
      },
    );
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
    await audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
  }
}
