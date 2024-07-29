import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_states.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

class CrudPlaylistSongsCubit extends Cubit<CrudPlaylistSongsState> {
  CrudPlaylistSongsCubit() : super(PlaylistSongsInitialState());
  void addSongsToPlayList(
      {required MyPlaylistModel playlistModel,
      required List<int> mySongModelIdsList}) {
    emit(PlaylistSongsLoadingState());
    try {
      playlistModel.mysongModelsIdList.addAll(mySongModelIdsList);
      playlistModel.save();
      emit(PlaylistSongsSuccessState());
    } on Exception catch (e) {
      emit(PlaylistSongsFailureState(errMsg: e.toString()));
    }
  }

  void listenToSongIndex({required AudioPlayer audioplayer}) {
    int x = 1;
    audioplayer.currentIndexStream.listen(
      (event) {
        if (x > 1) {
          emit(PlaylistSongsRefreshState(cubitCurrentIndex: event ?? 0));
        } else {
          x++;
        }
      },
    );
  }

  void deleteSongsFromPlayList(
      {required MyPlaylistModel playlistModel,
      required List<int> mySongModelIdsList}) {
    emit(PlaylistSongsLoadingState());
    try {
      playlistModel.mysongModelsIdList.removeWhere(
        (element) {
          return mySongModelIdsList.contains(element);
        },
      );
      playlistModel.save();
      emit(PlaylistSongsSuccessState());
    } on Exception catch (e) {
      emit(PlaylistSongsFailureState(errMsg: e.toString()));
    }
  }

  void resetPlayListUi() {
    emit(PlayListStopCurrentIndex(cubitCurrentIndex: -1));
  }
}
