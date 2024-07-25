import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/custome_text_field.dart';
import 'package:music_player_app/widgets/song_item.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<MySongModel> songModelsList = [];
  int getIndex(int id, List<MySongModel> songModelsList) {
    for (int i = 0; i < songModelsList.length; i++) {
      if (songModelsList[i].id == id) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xff303151).withOpacity(.5),
            const Color(0xff303151).withOpacity(.8),
            Colors.purple,
          ])),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            addHieghtSpace(12),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(CupertinoIcons.back)),
            ),
            addHieghtSpace(12),
            CustomeTextField(
              onChanged: (value) async {
                songModelsList = BlocProvider.of<MusicCubit>(context)
                    .myPublicSongModelList
                    .where((song) {
                  return song.title.toLowerCase().contains(value.toLowerCase());
                }).toList();
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {});
              },
            ),
            addHieghtSpace(16),
            Divider(),
            addHieghtSpace(16),
            Expanded(
              child: Builder(builder: (context) {
                return songModelsList.isEmpty
                    ? Center(
                        child: Text("There Is No Song Match That Name"),
                      )
                    : ListView.builder(
                        itemCount: songModelsList.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                BlocProvider.of<FavourateSongsCubit>(context)
                                    .audioPlayer
                                    .stop();
                                BlocProvider.of<PlaylistCubit>(context)
                                    .audioPlayer
                                    .stop();
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MusicPlayingView(
                                      currentIndex: getIndex(
                                          songModelsList[index].id,
                                          BlocProvider.of<MusicCubit>(context)
                                              .myPublicSongModelList),
                                      audioPlayer:
                                          BlocProvider.of<MusicCubit>(context)
                                              .audioPlayer,
                                      mySongModelsList:
                                          BlocProvider.of<MusicCubit>(context)
                                              .myPublicSongModelList,
                                    );
                                  },
                                ));
                              },
                              child: SongItem(
                                  songModel:
                                      songModelsList[index].toSongModel(),
                                  isActive: false),
                            ),
                          );
                        },
                      );
              }),
            )
          ],
        ),
      )),
    );
  }
}
