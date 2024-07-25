import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';

class BottomMusicContainerPlayAndPauseButton extends StatelessWidget {
  const BottomMusicContainerPlayAndPauseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (BlocProvider.of<BottomMusicContainerCubit>(context).isPlaying!) {
            BlocProvider.of<BottomMusicContainerCubit>(context).pauseMusic();
          } else {
            BlocProvider.of<BottomMusicContainerCubit>(context).playMusic();
          }
        },
        icon: BlocProvider.of<BottomMusicContainerCubit>(context).isPlaying!
            ? Icon(
                Icons.pause_rounded,
                size: 35,
                color: Colors.white,
              )
            : Icon(
                Icons.play_arrow_rounded,
                size: 35,
                color: Colors.white,
              ));
  }
}
