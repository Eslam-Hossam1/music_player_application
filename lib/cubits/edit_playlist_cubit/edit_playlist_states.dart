class EditPlaylistStates {}

class EditPlaylistInitialState extends EditPlaylistStates {}

class EditPlaylistLoadingState extends EditPlaylistStates {}

class EditPlaylistSuccessState extends EditPlaylistStates {}

class EditPlaylistFailureState extends EditPlaylistStates {
  final String errMsg;
  EditPlaylistFailureState({required this.errMsg});
}
