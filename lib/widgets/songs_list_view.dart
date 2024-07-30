import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit_states.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/get_last_song_played_index.dart';
import 'package:music_player_app/helper/seek_audio_to_current_index.dart';
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
    log("init 1");
    mySongModelList = BlocProvider.of<MusicCubit>(context).fetchMySongModels();
    currentIndex = getLastSongPlayedIndex(mySongModelList);
    BlocProvider.of<MusicCubit>(context).setupAudioPlayer(mySongModelList).then(
      (value) async {
        await seekAudioToCurrenIndex(
            currentIndex, BlocProvider.of<MusicCubit>(context).audioPlayer);
        BlocProvider.of<BottomMusicContainerCubit>(context)
            .inializeBottomMusicContainer(
                currentIndex: currentIndex,
                audioPlayer: BlocProvider.of<MusicCubit>(context).audioPlayer,
                songModelList: mySongModelList);
        BlocProvider.of<MusicCubit>(context).listenToSongIndex(
            audioplayer: BlocProvider.of<MusicCubit>(context).audioPlayer);
        BlocProvider.of<MusicCubit>(context).referenceBool.isAudioSetted = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: BlocBuilder<MusicCubit, MusicState>(builder: (context, state) {
        if (state is MusicInternalChangeCurrentIndexState) {
          if (state.cubitCurrentIndex < mySongModelList.length) {
            currentIndex = state.cubitCurrentIndex;

            Hive.box<int>(kLastSongIdPlayedBox)
                .put(kLastSongIdPlayedKey, mySongModelList[currentIndex].id);
          }
        }
        if (state is MusicExternalChangeCurrentIndexState) {
          currentIndex = state.toBeCurrentIndex;
        }
        if (mySongModelList.isNotEmpty) {
          return ListView.builder(
            itemCount: mySongModelList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<FavourateSongsCubit>(context)
                      .resetFavourateListAndStopAudio();
                  BlocProvider.of<PlaylistCubit>(context).stopPlaylistAudio();
                  BlocProvider.of<CrudPlaylistSongsCubit>(context)
                      .resetPlayListUi();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MusicPlayingView(
                          referenceBool: BlocProvider.of<MusicCubit>(context)
                              .referenceBool,
                          currentIndex: index,
                          audioPlayer:
                              BlocProvider.of<MusicCubit>(context).audioPlayer,
                          mySongModelsList: mySongModelList);
                    },
                  ));
                  BlocProvider.of<MusicCubit>(context).listenToSongIndex(
                      audioplayer:
                          BlocProvider.of<MusicCubit>(context).audioPlayer);
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
          );
        } else {
          return Center(
            child: Text("You Don't Have Songs In Your Device"),
          );
        }
      }),
    );
  }
}
