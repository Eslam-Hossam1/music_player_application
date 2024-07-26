import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        BlocProvider.of<MusicCubit>(context).audioPlayer.stop();

        BlocProvider.of<PlaylistCubit>(context).audioPlayer
          ..stop()
          ..setShuffleModeEnabled(false);

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MusicPlayingView(
                audioPlayer:
                    BlocProvider.of<PlaylistCubit>(context).audioPlayer,
                mySongModelsList: playlistSongModels,
                currentIndex: 0);
          },
        ));
      },
      backgroundColor: Colors.white,
      internalColor: const Color(0xff30314d),
      text: "Play All",
      iconData: Icons.play_arrow_rounded,
    );
  }
}
