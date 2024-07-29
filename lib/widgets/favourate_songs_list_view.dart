import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_states.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/song_item.dart';

class FavourateSongsListView extends StatefulWidget {
  const FavourateSongsListView({super.key});

  @override
  State<FavourateSongsListView> createState() => _FavourateSongsListViewState();
}

class _FavourateSongsListViewState extends State<FavourateSongsListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late List<MySongModel> mySongModelList;
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    mySongModelList = fetchSongs();
    currentIndex = -1;
  }

  List<MySongModel> fetchSongs() {
    List<MySongModel> mySongModelList =
        Hive.box<MySongModel>(kMySongModelBox).values.where(
      (element) {
        return element.isFavourate;
      },
    ).toList();
    mySongModelList.sort(
      (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
    );
    return mySongModelList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FavourateSongsCubit, FavourateSongsStates>(
        builder: (context, state) {
      if (state is FavourateSongsPlayListChangeCurrentIndex) {
        if (state.cubitCurrentIndex < mySongModelList.length) {
          currentIndex = state.cubitCurrentIndex;

          Hive.box<int>(kLastSongIdPlayedBox)
              .put(kLastSongIdPlayedKey, mySongModelList[currentIndex].id);
        }
      } else if (state is FavourateSongsPlayListStopCurrentIndex) {
        currentIndex = state.cubitCurrentIndex;
      } else {
        mySongModelList = fetchSongs();
      }
      return mySongModelList.isEmpty
          ? Center(
              child: Text("There is no favourate Song,  Add one"),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: ListView.builder(
                itemCount: mySongModelList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          BlocProvider.of<MusicCubit>(context)
                              .stopMainMusicAudio();

                          BlocProvider.of<PlaylistCubit>(context)
                              .stopPlaylistAudio();
                          BlocProvider.of<CrudPlaylistSongsCubit>(context)
                              .resetPlayListUi();
                          return MusicPlayingView(
                              referenceBool:
                                  BlocProvider.of<FavourateSongsCubit>(context)
                                      .referenceBool,
                              currentIndex: index,
                              audioPlayer:
                                  BlocProvider.of<FavourateSongsCubit>(context)
                                      .audioPlayer,
                              mySongModelsList: mySongModelList);
                        },
                      ));
                      BlocProvider.of<FavourateSongsCubit>(context)
                          .listenToSongIndex(
                              audioplayer:
                                  BlocProvider.of<FavourateSongsCubit>(context)
                                      .audioPlayer);
                      BlocProvider.of<MusicCubit>(context)
                          .listenToExternalSongIndex(
                              BlocProvider.of<FavourateSongsCubit>(context)
                                  .audioPlayer,
                              mySongModelList);
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
    });
  }
}
