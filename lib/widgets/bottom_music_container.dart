import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_states.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_reference_bool.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/bottom_music_container_play_and_pause_button.dart';
import 'package:music_player_app/widgets/bottom_music_container_seek_next_button.dart';

class BottomMusicContainer extends StatelessWidget {
  const BottomMusicContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomMusicContainerCubit, BottomMusicContainerStates>(
        builder: (context, state) {
      if (state is BottomMusicContainerSuccessStates) {
        var bottomMusicCubit =
            BlocProvider.of<BottomMusicContainerCubit>(context);
        if (bottomMusicCubit.songModelList!.isNotEmpty) {
          return Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(bottomMusicCubit
                  .songModelList![bottomMusicCubit.currentIndex!]
                  .primaryPaletteColor
                  .colorValue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MusicPlayingView(
                          referenceBool: MyReferenceBool(isAudioSetted: true),
                          audioPlayer:
                              BlocProvider.of<BottomMusicContainerCubit>(
                                      context)
                                  .audioPlayer!,
                          mySongModelsList:
                              BlocProvider.of<BottomMusicContainerCubit>(
                                      context)
                                  .songModelList!,
                          currentIndex:
                              BlocProvider.of<BottomMusicContainerCubit>(
                                      context)
                                  .currentIndex!);
                    },
                  ));
                },
                child: Row(
                  children: [
                    addWidthSpace(8),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: "lol",
                          child: bottomMusicCubit
                                      .songModelList![
                                          bottomMusicCubit.currentIndex!]
                                      .artworkString ==
                                  null
                              ? Image.asset(
                                  kApplicationIMage,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  bottomMusicCubit
                                      .songModelList![
                                          bottomMusicCubit.currentIndex!]
                                      .artworkString!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                            overflow: TextOverflow.ellipsis,
                            bottomMusicCubit
                                .songModelList![bottomMusicCubit.currentIndex!]
                                .title),
                        subtitle: Text(
                            overflow: TextOverflow.ellipsis,
                            bottomMusicCubit
                                        .songModelList![
                                            bottomMusicCubit.currentIndex!]
                                        .artist ==
                                    "<unknown>"
                                ? bottomMusicCubit
                                    .songModelList![
                                        bottomMusicCubit.currentIndex!]
                                    .title
                                : bottomMusicCubit
                                    .songModelList![
                                        bottomMusicCubit.currentIndex!]
                                    .artist!),
                      ),
                    ),
                    BottomMusicContainerPlayAndPauseButton(),
                    addWidthSpace(12),
                    BottomMusicContainerSeekNextButton(),
                    addWidthSpace(12)
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 6, 6, 6).withOpacity(.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
            ),
            child: Center(
              child: Text("Sorry No Song Exist"),
            ),
          );
        }
      } else {
        return Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 6, 6, 6).withOpacity(.7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
          ),
        );
      }
    });
  }
}
