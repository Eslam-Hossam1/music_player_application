import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_states.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

class AddAndDeletePlaylistCubit extends Cubit<AddAndDeletePlaylistStates> {
  AddAndDeletePlaylistCubit() : super(AddAndDeletePlaylistInitialState());
  final _playlistBox = Hive.box<MyPlaylistModel>(kMyPlaylistModelBox);
  Future<void> addPlayList({required String name}) async {
    emit(AddAndDeletePlaylistLoadingState());
    try {
      await _playlistBox
          .add(MyPlaylistModel(name: name, mysongModelsIdList: []));
      emit(AddAndDeletePlaylistSuccessState());
    } catch (e) {
      emit(AddAndDeletePlaylistFailureState(errMsg: e.toString()));
    }
  }

  void deletePlayLists(
      {required List<MyPlaylistModel> toDeletePlaylistsModels}) {
    for (var playlist in toDeletePlaylistsModels) {
      playlist.delete();
    }

    emit(AddAndDeletePlaylistSuccessState());
  }
}
