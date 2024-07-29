class MusicState {}

class MusicInitialState extends MusicState {}

class MusicLoadingState extends MusicState {}

class MusicFailureState extends MusicState {}

class MusicSuccessState extends MusicState {}

class MusicInternalChangeCurrentIndexState extends MusicState {
  int cubitCurrentIndex;
  MusicInternalChangeCurrentIndexState({required this.cubitCurrentIndex});
}

class MusicExternalChangeCurrentIndexState extends MusicState {
  int toBeCurrentIndex;
  MusicExternalChangeCurrentIndexState({required this.toBeCurrentIndex});
}
