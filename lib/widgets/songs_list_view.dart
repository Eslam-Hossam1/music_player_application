import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/get_last_song_played_index.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/favourate_music_playing_view.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/bottom_music_container.dart';
import 'package:music_player_app/widgets/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsListView extends StatefulWidget {
  const SongsListView({
    super.key,
  });

  @override
  State<SongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<SongsListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<MySongModel> mySongModelList = [];
  late int currentIndex;
  @override
  void initState() {
    super.initState();

    mySongModelList =
        BlocProvider.of<MusicCubit>(context).myPublicSongModelList;
    currentIndex = getLastSongPlayedIndex(mySongModelList);
    BlocProvider.of<MusicCubit>(context).setupAudioPlayer(mySongModelList).then(
      (value) async {
        await seekToCurrenIndex(currentIndex);
        BlocProvider.of<BottomMusicContainerCubit>(context)
            .inializeBottomMusicContainer(
                currentIndex: currentIndex,
                audioPlayer: BlocProvider.of<MusicCubit>(context).audioPlayer,
                songModelList: mySongModelList);
        listenToSongIndex();
      },
    );
  }

  Future<void> seekToCurrenIndex(int index) async {
    await BlocProvider.of<MusicCubit>(context)
        .audioPlayer
        .seek(Duration.zero, index: index);
  }

  //entire view
  void listenToSongIndex() {
    BlocProvider.of<MusicCubit>(context)
        .audioPlayer
        .currentIndexStream
        .listen((event) async {
      await Hive.box<int>(kLastSongIdPlayedBox)
          .put(kLastSongIdPlayedKey, mySongModelList[event ?? 3].id);

      if (event != null && mounted) {
        setState(() {
          currentIndex = event;
        });

        // await updatePaletteGenerator();
      }
    });
  }

  //play and pause button
  void listenToPlayingState() {
    BlocProvider.of<MusicCubit>(context)
        .audioPlayer
        .playerStateStream
        .listen((state) {
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
  // Future<void> sourceInitailize(List<SongModel> songModelList) async {
  //   List<AudioSource> audioSourceList = [];
  //   for (SongModel songModel in songModelList) {
  //     final artwork =
  //         await OnAudioQuery().queryArtwork(songModel.id, ArtworkType.AUDIO);
  //     String? artworkUri;

  //     if (artwork != null) {
  //       final tempDir = await getTemporaryDirectory();
  //       final file = await File('${tempDir.path}/${songModel.id}.png')
  //           .writeAsBytes(artwork);
  //       artworkUri = file.uri.toString();
  //     }
  //     audioSourceList.add(AudioSource.uri(
  //       Uri.parse(songModel.uri!),
  //       tag: MediaItem(
  //         id: songModel.id.toString(),
  //         album: songModel.album,
  //         title: songModel.title,
  //         artUri: artworkUri != null ? Uri.parse(artworkUri) : null,
  //       ),
  //     ));
  //   }
  //   await audioPlayer
  //       .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
  //   log("hhhhh");
  // }

  // List<MySongModel> fetchSongs() {
  //   List<MySongModel> mySongModelList =
  //       Hive.box<MySongModel>(kMySongModelBox).values.toList();
  //   mySongModelList.sort(
  //     (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
  //   );
  //   return mySongModelList;
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: mySongModelList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            BlocProvider.of<FavourateSongsCubit>(context).audioPlayer.stop();
            BlocProvider.of<PlaylistCubit>(context).audioPlayer.stop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MusicPlayingView(
                    currentIndex: index,
                    audioPlayer:
                        BlocProvider.of<MusicCubit>(context).audioPlayer,
                    mySongModelsList: mySongModelList);
              },
            ));
            listenToSongIndex();
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 14.0, right: 14, bottom: 8, top: 2),
            child: SongItem(
              isActive: currentIndex == index,
              songModel: mySongModelList[index].toSongModel(),
            ),
          ),
        );
      },
    );
  }
}
