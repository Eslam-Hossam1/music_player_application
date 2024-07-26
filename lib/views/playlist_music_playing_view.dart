import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/DetailsButton.dart';
import 'package:music_player_app/widgets/custome_play_and_pause_music_button.dart';
import 'package:music_player_app/widgets/custome_slider.dart';
import 'package:music_player_app/widgets/music_playing_view_artwork.dart';
import 'package:music_player_app/widgets/music_playing_view_list_tile.dart';
import 'package:music_player_app/widgets/shuffel_button.dart';

class PlaylistMusicPlayingView extends StatefulWidget {
  const PlaylistMusicPlayingView(
      {super.key,
      required this.mySongModelsList,
      required this.audioPlayer,
      required this.currentIndex});
  final List<MySongModel> mySongModelsList;
  final AudioPlayer audioPlayer;
  final int currentIndex;
  @override
  State<PlaylistMusicPlayingView> createState() =>
      _PlaylistMusicPlayingViewState();
}

class _PlaylistMusicPlayingViewState extends State<PlaylistMusicPlayingView> {
  late int currentIndex;

  bool firstBuild = true;
  @override
  void initState() {
    super.initState();
    if (widget.audioPlayer.playerState.playing &&
        widget.audioPlayer.currentIndex == widget.currentIndex) {
      currentIndex = widget.currentIndex;
      listenToSongIndex();
    } else {
      currentIndex = widget.currentIndex;

      BlocProvider.of<PlaylistCubit>(context)
          .setupAudioPlayer(widget.mySongModelsList)
          .then(
        (value) async {
          await seekToCurrenIndex(currentIndex);
          widget.audioPlayer.play();

          listenToSongIndex();
          BlocProvider.of<BottomMusicContainerCubit>(context)
              .inializeBottomMusicContainer(
                  currentIndex: currentIndex,
                  audioPlayer:
                      BlocProvider.of<PlaylistCubit>(context).audioPlayer,
                  songModelList: widget.mySongModelsList);
        },
      );
    }
  }

  Future<void> seekToCurrenIndex(int index) async {
    await widget.audioPlayer.seek(Duration.zero, index: index);
  }

  void listenToPlayingState() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void listenToSongIndex() {
    BlocProvider.of<PlaylistCubit>(context)
        .audioPlayer
        .currentIndexStream
        .listen((event) async {
      await Hive.box<int>(kLastSongIdPlayedBox)
          .put(kLastSongIdPlayedKey, widget.mySongModelsList[event ?? 3].id);

      if (event != null && mounted) {
        setState(() {
          currentIndex = event;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
          widget.mySongModelsList[currentIndex].primaryPaletteColor.colorValue),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 36,
                bottom: 12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.back,
                      size: 25,
                    )),
              ),
            ),
            Hero(
              tag: "lol",
              child: MusicPlayingViewArtWork(
                mySongModel: widget.mySongModelsList[currentIndex],
              ),
            ),
            addHieghtSpace(MediaQuery.of(context).size.height * .1),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .15,
                  child: MusicPlayingViewListTile(
                    mySongModel: widget.mySongModelsList[currentIndex],
                  ),
                ),
                CustomeSlider(audioPlayer: widget.audioPlayer),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (widget.audioPlayer.hasPrevious) {
                          widget.audioPlayer.seekToPrevious();
                        } else {
                          widget.audioPlayer.seek(Duration.zero,
                              index: widget.mySongModelsList.length - 1);
                        }
                        if (!widget.audioPlayer.playing) {
                          widget.audioPlayer.play();
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.backward_fill,
                        size: 50,
                        color: Color(widget.mySongModelsList[currentIndex]
                            .secondaryPaletteColor.colorValue),
                      ),
                    ),
                    CustomePlayAndPauseMusicButton(
                      audioPlayer: widget.audioPlayer,
                      color: Color(widget.mySongModelsList[currentIndex]
                          .secondaryPaletteColor.colorValue),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.audioPlayer.hasNext) {
                          widget.audioPlayer.seekToNext();
                        } else {
                          widget.audioPlayer.seek(Duration.zero, index: 0);
                        }
                        if (!widget.audioPlayer.playing) {
                          widget.audioPlayer.play();
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.forward_fill,
                        size: 50,
                        color: Color(widget.mySongModelsList[currentIndex]
                            .secondaryPaletteColor.colorValue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * .05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DetailsButton(
                      mySongModel: widget.mySongModelsList[currentIndex],
                    ),
                    ShuffleButton(
                      audioPlayer: widget.audioPlayer,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
