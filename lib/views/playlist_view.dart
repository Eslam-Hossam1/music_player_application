import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_states.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/helper/filter_database_playlist.dart';
import 'package:music_player_app/helper/get_my_song_model_from_id.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/bottom_music_container.dart';
import 'package:music_player_app/widgets/custome_popup_button.dart';
import 'package:music_player_app/widgets/playlist_view_play_all_button.dart';
import 'package:music_player_app/widgets/playlist_view_shuffle_button.dart';
import 'package:music_player_app/widgets/song_item.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({
    super.key,
    required this.myPlaylistModel,
  });
  final MyPlaylistModel myPlaylistModel;

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  MySongModel? songModel;

  late int currentIndex;
  late List<MySongModel> playlistSongModels;

  @override
  void initState() {
    super.initState();
    filterDatabaseModelList(widget.myPlaylistModel);
    playlistSongModels = fetchPlaylistSongs();
    currentIndex = -1;
    BlocProvider.of<PlaylistCubit>(context).referenceBool.isAudioSetted = false;
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
            body: Stack(
              children: [
                CustomScrollView(
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
                                CustomePopupMenuButton(widget: widget)
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
                              horizontal:
                                  MediaQuery.of(context).size.width * .2),
                          child: BlocBuilder<CrudPlaylistSongsCubit,
                                  CrudPlaylistSongsState>(
                              builder: (context, state) {
                            if (widget.myPlaylistModel.mysongModelsIdList
                                .isNotEmpty) {
                              songModel = getMySongModelFromId(
                                  widget.myPlaylistModel.mysongModelsIdList[0]);
                            } else {
                              songModel = null;
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: songModel == null
                                  ? Image.asset(
                                      "assets/music_jpeg_4x.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : songModel!.artworkString == null
                                      ? Image.asset(
                                          kApplicationIMage,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.memory(
                                          songModel!.artworkString!,
                                          fit: BoxFit.cover,
                                        ),
                            );
                          }),
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
                          BlocBuilder<CrudPlaylistSongsCubit,
                                  CrudPlaylistSongsState>(
                              builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PlaylistViewPlayAllButton(
                                    playlistSongModels: playlistSongModels),
                                PlaylistViewShuffelButton(
                                    playlistSongModels: playlistSongModels),
                              ],
                            );
                          }),
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
                    BlocBuilder<CrudPlaylistSongsCubit, CrudPlaylistSongsState>(
                        builder: (context, state) {
                      if (state is PlaylistSongsRefreshState) {
                        if (state.cubitCurrentIndex <
                            playlistSongModels.length) {
                          currentIndex = state.cubitCurrentIndex;

                          Hive.box<int>(kLastSongIdPlayedBox).put(
                              kLastSongIdPlayedKey,
                              playlistSongModels[currentIndex].id);
                        }
                      } else if (state is PlayListStopCurrentIndex) {
                        currentIndex = state.cubitCurrentIndex;
                      } else {
                        playlistSongModels = fetchPlaylistSongs();
                      }

                      return playlistSongModels.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .17),
                                child: Center(
                                  child: Text("There is no Song Add one"),
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.only(bottom: 90),
                              sliver: SliverList.builder(
                                itemCount: playlistSongModels.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0,
                                        right: 14,
                                        bottom: 8,
                                        top: 2),
                                    child: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<MusicCubit>(context)
                                            .stopMainMusicAudio();
                                        BlocProvider.of<FavourateSongsCubit>(
                                                context)
                                            .resetFavourateListAndStopAudio();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return MusicPlayingView(
                                                referenceBool: BlocProvider.of<
                                                        PlaylistCubit>(context)
                                                    .referenceBool,
                                                currentIndex: index,
                                                audioPlayer: BlocProvider.of<
                                                        PlaylistCubit>(context)
                                                    .audioPlayer,
                                                mySongModelsList:
                                                    playlistSongModels);
                                          },
                                        ));
                                        BlocProvider.of<CrudPlaylistSongsCubit>(
                                                context)
                                            .listenToSongIndex(
                                                audioplayer: BlocProvider.of<
                                                        PlaylistCubit>(context)
                                                    .audioPlayer);
                                        BlocProvider.of<MusicCubit>(context)
                                            .listenToExternalSongIndex(
                                                BlocProvider.of<PlaylistCubit>(
                                                        context)
                                                    .audioPlayer,
                                                playlistSongModels);
                                      },
                                      child: SongItem(
                                        mySongModel: playlistSongModels[index],
                                        isActive: currentIndex == index,
                                        songModel: playlistSongModels[index]
                                            .toSongModel(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                    }),
                  ],
                ),
                Positioned(bottom: 0, child: BottomMusicContainer())
              ],
            )),
      ),
    );
  }
}
