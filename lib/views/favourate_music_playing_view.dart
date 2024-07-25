import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/DetailsButton.dart';
import 'package:music_player_app/widgets/custome_play_and_pause_music_button.dart';
import 'package:music_player_app/widgets/custome_slider.dart';
import 'package:music_player_app/widgets/music_playing_view_artwork.dart';
import 'package:music_player_app/widgets/music_playing_view_list_tile.dart';
import 'package:music_player_app/widgets/shuffel_button.dart';

class FavourateMusicPlayingView extends StatefulWidget {
  const FavourateMusicPlayingView({
    super.key,
    required this.audioPlayer,
    required this.mySongModelsList,
    required this.currentIndex,
  });

  final List<MySongModel> mySongModelsList;
  final AudioPlayer audioPlayer;
  final int currentIndex;

  @override
  State<FavourateMusicPlayingView> createState() =>
      _FavourateMusicPlayingViewState();
}

class _FavourateMusicPlayingViewState extends State<FavourateMusicPlayingView> {
  // PaletteColor paletteColorList = PaletteColor(Colors.green, 2);
  //bool isPlaying = false;
  // final List<AudioSource> songsSourcesList = [];
  late int currentIndex;

  // ImageProvider? artworkImageProvider;
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
      // setAudioSource().then((_) {
      //   widget.audioPlayer.play();
      //   listenToSongIndex();
      // });
      BlocProvider.of<FavourateSongsCubit>(context)
          .setupAudioPlayer(widget.mySongModelsList)
          .then(
        (value) async {
          seekToCurrenIndex(currentIndex);
          widget.audioPlayer.play();
          // widget.audioPlayer.setShuffleModeEnabled(true);
          // log("shuffel mode " +
          //     widget.audioPlayer.shuffleModeEnabled.toString());
          listenToSongIndex();
          BlocProvider.of<BottomMusicContainerCubit>(context)
              .inializeBottomMusicContainer(
                  currentIndex: currentIndex,
                  audioPlayer:
                      BlocProvider.of<FavourateSongsCubit>(context).audioPlayer,
                  songModelList: widget.mySongModelsList);
          // listenToPlayingState();
          //  isPlaying = true;
        },
      );
    }
  }

  // Future<void> updatePaletteGenerator() async {
  //   try {
  //     Uint8List? artworkBytes = await OnAudioQuery().queryArtwork(
  //         widget.songModelsList[currentIndex].id, ArtworkType.AUDIO);

  //     if (artworkBytes != null) {
  //       artworkImageProvider = MemoryImage(artworkBytes);
  //     } else {
  //       artworkImageProvider = AssetImage('assets/default_artwork.png');
  //     }

  //     PaletteGenerator pg = await PaletteGenerator.fromImageProvider(
  //       artworkImageProvider!,
  //     );

  //     setState(() {
  //       paletteColorList = pg.darkVibrantColor ?? PaletteColor(Colors.grey, 2);
  //     });
  //   } catch (e) {
  //     log(e.toString());
  //     setState(() {
  //       artworkImageProvider = AssetImage('assets/default_artwork.png');
  //     });
  //   }
  // }

  Future<void> seekToCurrenIndex(int index) async {
    await widget.audioPlayer.seek(Duration.zero, index: index);
  }

  //play and pause button
  void listenToPlayingState() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        if (mounted) {
          setState(() {
            //    isPlaying = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            //   isPlaying = false;
          });
        }
      }
      // if (state.processingState == ProcessingState.completed) {
      //   setState(() {
      //     isPlaying = false;
      //   });
      // }
    });
  }

  //entire view
  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen((event) {
      if (event != null && mounted) {
        if (firstBuild) {
          firstBuild = false;
          currentIndex = event;
        } else {
          setState(() {
            currentIndex = event;
          });
        }
        // await updatePaletteGenerator();
      }
    });
  }

  // Future<void> setAudioSource() async {
  //   for (var element in widget.songModelsList) {
  //     final artwork =
  //         await OnAudioQuery().queryArtwork(element.id, ArtworkType.AUDIO);
  //     String? artworkUri;

  //     if (artwork != null) {
  //       final tempDir = await getTemporaryDirectory();
  //       final file = await File('${tempDir.path}/${element.id}.png')
  //           .writeAsBytes(artwork);
  //       artworkUri = file.uri.toString();
  //     }

  //     songsSourcesList.add(AudioSource.uri(
  //       Uri.parse(element.uri!),
  //       tag: MediaItem(
  //         id: element.id.toString(),
  //         album: element.album,
  //         title: element.title,
  //         artUri: artworkUri != null ? Uri.parse(artworkUri) : null,
  //       ),
  //     ));
  //   }
  //   await widget.audioPlayer.setAudioSource(
  //     ConcatenatingAudioSource(children: songsSourcesList),
  //     initialIndex: currentIndex,
  //   );
  //   log("Audio source set");
  // }

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
            MusicPlayingViewArtWork(
              songModel: widget.mySongModelsList[currentIndex].toSongModel(),
            ),
            const Spacer(),
            Column(
              children: [
                addHieghtSpace(12),
                MusicPlayingViewListTile(
                  mySongModel: widget.mySongModelsList[currentIndex],
                ),
                CustomeSlider(audioPlayer: widget.audioPlayer),
                addHieghtSpace(24),
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
            Expanded(
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
