import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/edit_playlist_cubit/edit_playlist_states.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

class EditPlaylistCubit extends Cubit<EditPlaylistStates> {
  EditPlaylistCubit() : super(EditPlaylistInitialState());
  void editPlaylistName(
      {required MyPlaylistModel playlistModel, required String newName}) {
    try {
      emit(EditPlaylistLoadingState());
      playlistModel.name = newName;
      playlistModel.save();
      emit(EditPlaylistSuccessState());
    } catch (e) {
      emit(EditPlaylistFailureState(errMsg: e.toString()));
    }
  }
}
