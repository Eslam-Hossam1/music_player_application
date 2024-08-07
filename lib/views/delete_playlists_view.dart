import 'package:flutter/material.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_cubit.dart';
import 'package:music_player_app/helper/get_my_song_model_from_id.dart';
import 'package:music_player_app/models/my_playlist_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/custome_elevated_button.dart';
import 'package:music_player_app/widgets/playlist_item.dart';

class DeletePlaylistsView extends StatefulWidget {
  const DeletePlaylistsView({super.key, required this.playlistsList});
  final List<MyPlaylistModel> playlistsList;
  @override
  State<DeletePlaylistsView> createState() => _DeletePlaylistsViewState();
}

class _DeletePlaylistsViewState extends State<DeletePlaylistsView> {
  List<MyPlaylistModel> toDeletePlaylistModelsList = [];
  List<bool> checkedStates = [];
  @override
  void initState() {
    super.initState();
    checkedStates = List<bool>.filled(widget.playlistsList.length, false);
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
                itemCount: widget.playlistsList.length,
                itemBuilder: (context, index) {
                  bool isChecked = checkedStates[index];
                  MySongModel? songModel;
                  if (widget
                      .playlistsList[index].mysongModelsIdList.isNotEmpty) {
                    songModel = getMySongModelFromId(
                        widget.playlistsList[index].mysongModelsIdList[0]);
                  } else {
                    songModel = null;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                        checkedStates[index] = isChecked;
                        if (isChecked) {
                          toDeletePlaylistModelsList
                              .add(widget.playlistsList[index]);
                        } else {
                          toDeletePlaylistModelsList
                              .remove(widget.playlistsList[index]);
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        PlaylistItem(
                          myPlaylistModel: widget.playlistsList[index],
                          mySongModel: songModel,
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Icon(isChecked
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomeElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AddAndDeletePlaylistCubit>(context)
                        .deletePlayLists(
                      toDeletePlaylistsModels: toDeletePlaylistModelsList,
                    );
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
