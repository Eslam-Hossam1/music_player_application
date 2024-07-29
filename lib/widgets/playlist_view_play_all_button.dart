import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';

class PlaylistViewPlayAllButton extends StatelessWidget {
  const PlaylistViewPlayAllButton({
    super.key,
    required this.playlistSongModels,
  });

  final List<MySongModel> playlistSongModels;

  @override
  Widget build(BuildContext context) {
    return CustomeElvatedButtonIcon(
      onPresed: () {
        BlocProvider.of<MusicCubit>(context).stopMainMusicAudio();
        BlocProvider.of<FavourateSongsCubit>(context)
            .resetFavourateListAndStopAudio();
        BlocProvider.of<PlaylistCubit>(context).stopPlaylistAudio();
        BlocProvider.of<PlaylistCubit>(context)
            .audioPlayer
            .setShuffleModeEnabled(false);

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MusicPlayingView(
                referenceBool:
                    BlocProvider.of<PlaylistCubit>(context).referenceBool,
                audioPlayer:
                    BlocProvider.of<PlaylistCubit>(context).audioPlayer,
                mySongModelsList: playlistSongModels,
                currentIndex: 0);
          },
        ));
        BlocProvider.of<CrudPlaylistSongsCubit>(context).listenToSongIndex(
            audioplayer: BlocProvider.of<PlaylistCubit>(context).audioPlayer);
        BlocProvider.of<MusicCubit>(context).listenToExternalSongIndex(
            BlocProvider.of<PlaylistCubit>(context).audioPlayer,
            playlistSongModels);
      },
      backgroundColor: Colors.white,
      internalColor: const Color(0xff30314d),
      text: "Play All",
      iconData: Icons.play_arrow_rounded,
    );
  }
}
