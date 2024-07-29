class CrudPlaylistSongsState {}

class PlaylistSongsInitialState extends CrudPlaylistSongsState {}

class PlaylistSongsLoadingState extends CrudPlaylistSongsState {}

class PlaylistSongsSuccessState extends CrudPlaylistSongsState {}

class PlaylistSongsRefreshState extends CrudPlaylistSongsState {
  int cubitCurrentIndex;
  PlaylistSongsRefreshState({required this.cubitCurrentIndex});
}

class PlaylistSongsFailureState extends CrudPlaylistSongsState {
  final String errMsg;
  PlaylistSongsFailureState({required this.errMsg});
}

class PlayListStopCurrentIndex extends CrudPlaylistSongsState {
  int cubitCurrentIndex;
  PlayListStopCurrentIndex({required this.cubitCurrentIndex});
}
