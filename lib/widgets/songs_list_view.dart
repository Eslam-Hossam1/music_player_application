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
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/song_item.dart';

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
    log("shit 3");
    mySongModelList = BlocProvider.of<MusicCubit>(context).fetchMySongModels();
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
      }
    });
  }

  void listenToPlayingState() {
    BlocProvider.of<MusicCubit>(context)
        .audioPlayer
        .playerStateStream
        .listen((state) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: ListView.builder(
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
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14, bottom: 8, top: 2),
              child: SongItem(
                mySongModel: mySongModelList[index],
                isActive: currentIndex == index,
                songModel: mySongModelList[index].toSongModel(),
              ),
            ),
          );
        },
      ),
    );
  }
}
