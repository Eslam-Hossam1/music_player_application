import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_states.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/get_last_song_played_index.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/favourate_music_playing_view.dart';
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
  dynamic filteredSongsList;
  late List<MySongModel> mySongModelList;
  late int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySongModelList = fetchSongs();
    currentIndex = getLastSongPlayedIndex(mySongModelList);
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
        try {
          if (state.cubitCurrentIndex < mySongModelList.length) {
            currentIndex = state.cubitCurrentIndex;

            Hive.box<int>(kLastSongIdPlayedBox)
                .put(kLastSongIdPlayedKey, mySongModelList[currentIndex].id);
          }
        } on Exception catch (e) {
          log(e.toString());
        }
      } else {
        mySongModelList = fetchSongs();
      }

      return mySongModelList.isEmpty
          ? Center(
              child: Text("There is no favourate song,Add one"),
            )
          : ListView.builder(
              itemCount: mySongModelList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        BlocProvider.of<MusicCubit>(context).audioPlayer.stop();
                        BlocProvider.of<PlaylistCubit>(context)
                            .audioPlayer
                            .stop();
                        return MusicPlayingView(
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 14.0, right: 14, bottom: 8, top: 2),
                    child: SongItem(
                      isActive: currentIndex == index,
                      songModel: mySongModelList[index].toSongModel(),
                    ),
                  ),
                );
              },
            );
    });
  }
}
