import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_songs_cubit/add_and_delete_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_songs_cubit/add_and_delete_playlist_songs_states.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/helper/get_last_song_played_index.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/add_songs_to_playlist_view.dart';
import 'package:music_player_app/views/delete_songs_from_playlist_view.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/views/playlist_music_playing_view.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';
import 'package:music_player_app/widgets/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({super.key, required this.myPlaylistModel});
  final MyPlaylistModel myPlaylistModel;

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  late int currentIndex;
  late List<MySongModel> playlistSongModels;
  @override
  void initState() {
    super.initState();

    playlistSongModels = fetchPlaylistSongs();
    currentIndex = getLastSongPlayedIndex(playlistSongModels);
    // listenToSongIndex();
  }

  void listenToSongIndex() {
    BlocProvider.of<MusicCubit>(context)
        .audioPlayer
        .currentIndexStream
        .listen((event) async {
      await Hive.box<int>(kLastSongIdPlayedBox)
          .put(kLastSongIdPlayedKey, playlistSongModels[event ?? 3].id);

      if (event != null && mounted) {
        setState(() {
          currentIndex = event;
        });

        // await updatePaletteGenerator();
      }
    });
  }

  List<MySongModel> fetchPlaylistSongs() {
    List<MySongModel> myPublicSongModelList =
        BlocProvider.of<MusicCubit>(context).myPublicSongModelList;
    playlistSongModels = myPublicSongModelList.where(
      (song) {
        return widget.myPlaylistModel.mysongModelsIdList.contains(song.id);
      },
    ).toList();
    return playlistSongModels;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xff303151).withOpacity(1),
            const Color(0xff303151).withOpacity(1),
            Colors.purple,
          ])),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(CupertinoIcons.back)),
                            const Spacer(),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Add Songs"),
                                        Icon(Icons.add_box_outlined)
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return AddSongsToPlaylistView(
                                            myPlaylistModel:
                                                widget.myPlaylistModel,
                                          );
                                        },
                                      ));
                                    },
                                  ),
                                  PopupMenuItem(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Delete Songs"),
                                          Icon(CupertinoIcons.delete_simple)
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DeleteSongsFromPlaylistView(
                                                myPlaylistModel:
                                                    widget.myPlaylistModel,
                                              );
                                            },
                                          ),
                                        );
                                      })
                                ];
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: addHieghtSpace(16)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 230,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .2),
                      child: Hero(
                        tag: "lol2",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              widget.myPlaylistModel.mysongModelsIdList.isEmpty
                                  ? Image.asset(
                                      "assets/music_jpeg_4x.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : QueryArtworkWidget(
                                      id: widget.myPlaylistModel
                                          .mysongModelsIdList[0],
                                      type: ArtworkType.AUDIO,
                                      artworkFit: BoxFit.cover,
                                      artworkBorder: BorderRadius.zero,
                                      size: 512,
                                      nullArtworkWidget: Image.asset(
                                        "assets/music_jpeg_4x.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: addHieghtSpace(16)),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        widget.myPlaylistModel.name,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      addHieghtSpace(32),
                      IgnorePointer(
                        ignoring:
                            widget.myPlaylistModel.mysongModelsIdList.isEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomeElvatedButtonIcon(
                              onPresed: () {
                                BlocProvider.of<MusicCubit>(context)
                                    .audioPlayer
                                    .stop();

                                BlocProvider.of<PlaylistCubit>(context)
                                    .audioPlayer
                                  ..stop()
                                  ..setShuffleModeEnabled(false);

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MusicPlayingView(
                                        audioPlayer:
                                            BlocProvider.of<PlaylistCubit>(
                                                    context)
                                                .audioPlayer,
                                        mySongModelsList: playlistSongModels,
                                        currentIndex: 0);
                                  },
                                ));
                              },
                              backgroundColor: Colors.white,
                              internalColor: const Color(0xff30314d),
                              text: "Play All",
                              iconData: Icons.play_arrow_rounded,
                            ),
                            CustomeElvatedButtonIcon(
                              backgroundColor: Color(0xff30314d),
                              internalColor: Colors.white,
                              text: "Shuffle",
                              iconData: Icons.shuffle,
                              onPresed: () {
                                BlocProvider.of<MusicCubit>(context)
                                    .audioPlayer
                                    .stop();

                                BlocProvider.of<PlaylistCubit>(context)
                                    .audioPlayer
                                  ..stop()
                                  ..setShuffleModeEnabled(true);

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PlaylistMusicPlayingView(
                                        audioPlayer:
                                            BlocProvider.of<PlaylistCubit>(
                                                    context)
                                                .audioPlayer,
                                        mySongModelsList: playlistSongModels,
                                        currentIndex: 0);
                                  },
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      addHieghtSpace(12),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    endIndent: 12,
                    indent: 12,
                    color: Colors.white.withOpacity(.7),
                    thickness: 1,
                  ),
                ),
                BlocBuilder<AddAndDeletePlaylistSongsCubit,
                    AddAndDeletePlaylistSongsState>(builder: (context, state) {
                  if (state is AddAndDeletePlaylistSongsRefreshState) {
                    try {
                      if (state.cubitCurrentIndex < playlistSongModels.length) {
                        currentIndex = state.cubitCurrentIndex;

                        Hive.box<int>(kLastSongIdPlayedBox).put(
                            kLastSongIdPlayedKey,
                            playlistSongModels[currentIndex].id);
                      }
                    } on Exception catch (e) {
                      log(e.toString());
                    }
                  } else {
                    playlistSongModels = fetchPlaylistSongs();
                  }

                  return playlistSongModels.isEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .17),
                            child: Center(
                              child: Text("There is no Songs Add one"),
                            ),
                          ),
                        )
                      : SliverList.builder(
                          itemCount: playlistSongModels.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 14, bottom: 8, top: 2),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<MusicCubit>(context)
                                      .audioPlayer
                                      .stop();
                                  BlocProvider.of<FavourateSongsCubit>(context)
                                      .audioPlayer
                                      .stop();
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MusicPlayingView(
                                          currentIndex: index,
                                          audioPlayer:
                                              BlocProvider.of<PlaylistCubit>(
                                                      context)
                                                  .audioPlayer,
                                          mySongModelsList: playlistSongModels);
                                    },
                                  ));
                                  BlocProvider.of<
                                              AddAndDeletePlaylistSongsCubit>(
                                          context)
                                      .listenToSongIndex(
                                          audioplayer:
                                              BlocProvider.of<PlaylistCubit>(
                                                      context)
                                                  .audioPlayer);
                                },
                                child: SongItem(
                                  isActive: currentIndex == index,
                                  songModel:
                                      playlistSongModels[index].toSongModel(),
                                ),
                              ),
                            );
                          },
                        );
                }),
              ],
            )),
      ),
    );
  }
}
