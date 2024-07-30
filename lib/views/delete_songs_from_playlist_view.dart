import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/checkbox_song_item.dart';
import 'package:music_player_app/widgets/custome_elevated_button.dart';

class DeleteSongsFromPlaylistView extends StatefulWidget {
  const DeleteSongsFromPlaylistView({super.key, required this.myPlaylistModel});
  final MyPlaylistModel myPlaylistModel;
  @override
  State<DeleteSongsFromPlaylistView> createState() =>
      _DeleteSongsFromPlaylistViewState();
}

class _DeleteSongsFromPlaylistViewState
    extends State<DeleteSongsFromPlaylistView> {
  late List<MySongModel> mySongModelList;
  List<int> toDeleteSongModelsIdList = [];
  int currentIndex = 0;
  List<bool> checkedStates = [];

  @override
  void initState() {
    super.initState();
    mySongModelList =
        BlocProvider.of<MusicCubit>(context).myPublicSongModelList;
    filterSongsNotInPlaylist();
    checkedStates = List<bool>.filled(mySongModelList.length, false);
  }

  List<MySongModel> fetchSongs() {
    List<MySongModel> mySongModelList =
        Hive.box<MySongModel>(kMySongModelBox).values.toList();
    mySongModelList.sort(
      (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
    );
    return mySongModelList;
  }

  void filterSongsNotInPlaylist() {
    // Set<int> playlistSongIds =
    //     widget.myPlaylistModel.mysongModelList.map((song) => song.id).toSet();
    mySongModelList = mySongModelList
        .where((song) =>
            widget.myPlaylistModel.mysongModelsIdList.contains(song.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xff303151),
            const Color(0xff303151),
            Colors.purple,
          ])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              ListView.builder(
                itemCount: mySongModelList.length,
                itemBuilder: (context, index) {
                  bool isChecked = checkedStates[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                        checkedStates[index] = isChecked;
                        if (isChecked) {
                          toDeleteSongModelsIdList
                              .add(mySongModelList[index].id);
                        } else {
                          toDeleteSongModelsIdList
                              .remove(mySongModelList[index].id);
                        }
                      });
                    },
                    child: CheckboxSongItem(
                      songModel: mySongModelList[index].toSongModel(),
                      isChecked: isChecked,
                      mySongModel: mySongModelList[index],
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomeElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CrudPlaylistSongsCubit>(context)
                        .deleteSongsFromPlayList(
                            playlistModel: widget.myPlaylistModel,
                            mySongModelIdsList: toDeleteSongModelsIdList);
                    BlocProvider.of<PlaylistCubit>(context).fetchPlayLists();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
