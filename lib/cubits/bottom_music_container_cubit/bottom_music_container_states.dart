class BottomMusicContainerStates {}

class BottomMusicContainerInitialStates extends BottomMusicContainerStates {}

class BottomMusicContainerSuccessStates extends BottomMusicContainerStates {}

class BottomMusicContainerLoadingStates extends BottomMusicContainerStates {}

class BottomMusicContainerFailureStates extends BottomMusicContainerStates {
  String errMsg;
  BottomMusicContainerFailureStates({required this.errMsg});
}
