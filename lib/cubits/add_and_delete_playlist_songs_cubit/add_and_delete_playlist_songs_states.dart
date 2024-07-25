class AddAndDeletePlaylistSongsState {}

class AddAndDeletePlaylistSongsInitialState
    extends AddAndDeletePlaylistSongsState {}

class AddAndDeletePlaylistSongsLoadingState
    extends AddAndDeletePlaylistSongsState {}

class AddAndDeletePlaylistSongsSuccessState
    extends AddAndDeletePlaylistSongsState {}

class AddAndDeletePlaylistSongsRefreshState
    extends AddAndDeletePlaylistSongsState {
  int cubitCurrentIndex;
  AddAndDeletePlaylistSongsRefreshState({required this.cubitCurrentIndex});
}

class AddAndDeletePlaylistSongsFailureState
    extends AddAndDeletePlaylistSongsState {
  final String errMsg;
  AddAndDeletePlaylistSongsFailureState({required this.errMsg});
}
