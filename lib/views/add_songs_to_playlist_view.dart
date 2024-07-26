import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_songs_cubit/add_and_delete_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/checkbox_song_item.dart';
import 'package:music_player_app/widgets/custome_elevated_button.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';
import 'package:music_player_app/widgets/song_item.dart';

class AddSongsToPlaylistView extends StatefulWidget {
  const AddSongsToPlaylistView({super.key, required this.myPlaylistModel});
  final MyPlaylistModel myPlaylistModel;

  @override
  State<AddSongsToPlaylistView> createState() => _AddSongsToPlaylistViewState();
}

class _AddSongsToPlaylistViewState extends State<AddSongsToPlaylistView> {
  late List<MySongModel> mySongModelList;
  List<int> toAddSongModelsIdList = [];
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
            !widget.myPlaylistModel.mysongModelsIdList.contains(song.id))
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
                          toAddSongModelsIdList.add(mySongModelList[index].id);
                        } else {
                          toAddSongModelsIdList
                              .remove(mySongModelList[index].id);
                        }
                      });
                      log(mySongModelList[index].id.toString());
                    },
                    child: CheckboxSongItem(
                      mySongModel: mySongModelList[index],
                      songModel: mySongModelList[index].toSongModel(),
                      isChecked: isChecked,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomeElevatedButton(
                  onPressed: () {
                    log(toAddSongModelsIdList.toString());
                    BlocProvider.of<AddAndDeletePlaylistSongsCubit>(context)
                        .addSongsToPlayList(
                            playlistModel: widget.myPlaylistModel,
                            mySongModelIdsList: toAddSongModelsIdList);
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
