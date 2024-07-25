class AddAndDeletePlaylistStates {}

class AddAndDeletePlaylistInitialState extends AddAndDeletePlaylistStates {}

class AddAndDeletePlaylistLoadingState extends AddAndDeletePlaylistStates {}

class AddAndDeletePlaylistSuccessState extends AddAndDeletePlaylistStates {}

class AddAndDeletePlaylistFailureState extends AddAndDeletePlaylistStates {
  final String errMsg;
  AddAndDeletePlaylistFailureState({required this.errMsg});
}
