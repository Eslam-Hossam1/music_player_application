class FavourateSongsStates {}

class FavourateSongsInitialState extends FavourateSongsStates {}

class ChangeOccuredState extends FavourateSongsStates {}

class FavourateSongsPlayListChangeCurrentIndex extends FavourateSongsStates {
  int cubitCurrentIndex;
  FavourateSongsPlayListChangeCurrentIndex({required this.cubitCurrentIndex});
}

class FavourateSongsPlayListStopCurrentIndex extends FavourateSongsStates {
  int cubitCurrentIndex;
  FavourateSongsPlayListStopCurrentIndex({required this.cubitCurrentIndex});
}
