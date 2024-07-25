class PlaylistStates {}

class PlaylistInitialState extends PlaylistStates {}

class PlaylistLoadingState extends PlaylistStates {}

class PlaylistSuccessState extends PlaylistStates {}

class PlaylistFailureState extends PlaylistStates {
  final String errMsg;
  PlaylistFailureState({required this.errMsg});
}
