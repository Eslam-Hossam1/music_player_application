import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_songs_cubit/add_and_delete_playlist_songs_states.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

class AddAndDeletePlaylistSongsCubit
    extends Cubit<AddAndDeletePlaylistSongsState> {
  AddAndDeletePlaylistSongsCubit()
      : super(AddAndDeletePlaylistSongsInitialState());
  void addSongsToPlayList(
      {required MyPlaylistModel playlistModel,
      required List<int> mySongModelIdsList}) {
    emit(AddAndDeletePlaylistSongsLoadingState());
    try {
      playlistModel.mysongModelsIdList.addAll(mySongModelIdsList);
      playlistModel.save();
      emit(AddAndDeletePlaylistSongsSuccessState());
    } on Exception catch (e) {
      emit(AddAndDeletePlaylistSongsFailureState(errMsg: e.toString()));
    }
  }

  void listenToSongIndex({required AudioPlayer audioplayer}) {
    audioplayer.currentIndexStream.listen(
      (event) {
        emit(AddAndDeletePlaylistSongsRefreshState(
            cubitCurrentIndex: event ?? 0));
      },
    );
  }

  void deleteSongsFromPlayList(
      {required MyPlaylistModel playlistModel,
      required List<int> mySongModelIdsList}) {
    emit(AddAndDeletePlaylistSongsLoadingState());
    try {
      playlistModel.mysongModelsIdList.removeWhere(
        (element) {
          return mySongModelIdsList.contains(element);
        },
      );
      playlistModel.save();
      emit(AddAndDeletePlaylistSongsSuccessState());
    } on Exception catch (e) {
      emit(AddAndDeletePlaylistSongsFailureState(errMsg: e.toString()));
    }
  }
}
