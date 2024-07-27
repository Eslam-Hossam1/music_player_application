import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_states.dart';
import 'package:music_player_app/models/my_song_model.dart';

class BottomMusicContainerCubit extends Cubit<BottomMusicContainerStates> {
  BottomMusicContainerCubit() : super(BottomMusicContainerInitialStates());

  int? currentIndex;
  AudioPlayer? audioPlayer;
  List<MySongModel>? songModelList;
  bool? isPlaying;
  void inializeBottomMusicContainer(
      {required int currentIndex,
      required AudioPlayer audioPlayer,
      required List<MySongModel> songModelList}) {
    this.currentIndex = currentIndex;
    this.audioPlayer = audioPlayer;
    this.songModelList = songModelList;
    this.isPlaying = audioPlayer.playing;
    listenToCurrenIndex(this.audioPlayer!);
    listToPlayingState(this.audioPlayer!);
  }

  void seekToNext() {
    this.audioPlayer!.seekToNext();
    if (!this.audioPlayer!.playing) {
      this.audioPlayer!.play();
    }
  }

  void listToPlayingState(AudioPlayer audioPlayer) {
    audioPlayer.playingStream.listen(
      (event) {
        this.isPlaying = event;
        emit(BottomMusicContainerSuccessStates());
      },
    );
  }

  void playMusic() {
    this.audioPlayer!.play();
  }

  void pauseMusic() {
    this.audioPlayer!.pause();
  }

  void listenToCurrenIndex(AudioPlayer audioPlayer) {
    audioPlayer.currentIndexStream.listen(
      (event) {
        //   log("hi");
        this.currentIndex = event!;
        emit(BottomMusicContainerSuccessStates());
      },
    );
  }
}
