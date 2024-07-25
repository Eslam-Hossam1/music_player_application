import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_state.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/views/delete_playlists_view.dart';
import 'package:music_player_app/views/playlist_view.dart';
import 'package:music_player_app/widgets/add_playlist_dialog.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';
import 'package:music_player_app/widgets/edit_playlist_dialoag.dart';
import 'package:music_player_app/widgets/playlist_item.dart';
import 'package:music_player_app/widgets/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistsTabBarView extends StatefulWidget {
  const PlaylistsTabBarView({
    super.key,
  });

  @override
  State<PlaylistsTabBarView> createState() => _PlaylistsTabBarViewState();
}

class _PlaylistsTabBarViewState extends State<PlaylistsTabBarView>
    with AutomaticKeepAliveClientMixin {
  late List<MyPlaylistModel> playlistModelsList;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlaylistCubit>(context).fetchPlayLists();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomeElvatedButtonIcon(
                text: "Add PlayList",
                iconData: Icons.add_box,
                backgroundColor: Color(0xff30314d),
                internalColor: Colors.white,
                onPresed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AddPlaylistDialoag();
                    },
                  );
                },
              ),
              CustomeElvatedButtonIcon(
                text: "Delete PlayList",
                iconData: CupertinoIcons.delete_solid,
                backgroundColor: Color(0xff30314d),
                internalColor: Colors.white,
                onPresed: () {
                  if (playlistModelsList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.grey.shade900,
                        duration: Duration(milliseconds: 1500),
                        content: Text(
                          "there is no playlist to delete",
                          style: TextStyle(color: Colors.white),
                        )));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeletePlaylistsView(
                          playlistsList: playlistModelsList,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: addHieghtSpace(16)),
        BlocBuilder<PlaylistCubit, PlaylistStates>(
          builder: (context, state) {
            playlistModelsList =
                BlocProvider.of<PlaylistCubit>(context).myPlaylistModelsList;
            if (state is PlaylistFailureState) {
              return SliverToBoxAdapter(
                child: Center(child: Text(state.errMsg)),
              );
            } else if (state is PlaylistLoadingState) {
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return playlistModelsList.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .25),
                        child: Center(
                          child: Text("There is no playlist , Add one"),
                        ),
                      ),
                    )
                  : SliverList.builder(
                      itemCount: playlistModelsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EditPlaylistDialoag(
                                    playlistModel: playlistModelsList[index]);
                              },
                            );
                          },
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return PlaylistView(
                                    myPlaylistModel: playlistModelsList[index]);
                              },
                            ));
                          },
                          child: PlaylistItem(
                              myPlaylistModel: playlistModelsList[index]),
                        );
                      },
                    );
            }
          },
        ),
      ],
    );
  }
}
