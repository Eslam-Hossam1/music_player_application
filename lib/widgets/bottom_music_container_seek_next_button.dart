import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';

class BottomMusicContainerSeekNextButton extends StatelessWidget {
  const BottomMusicContainerSeekNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          BlocProvider.of<BottomMusicContainerCubit>(context).seekToNext();
        },
        icon: Icon(
          CupertinoIcons.forward_fill,
          color: Colors.white,
          size: 25,
        ));
  }
}
