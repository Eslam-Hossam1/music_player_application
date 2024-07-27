import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/edit_playlist_cubit/edit_playlist_cubit.dart';
import 'package:music_player_app/cubits/edit_playlist_cubit/edit_playlist_states.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/widgets/edit_playlist_form.dart';

class EditPlaylistDialoag extends StatefulWidget {
  const EditPlaylistDialoag({super.key, required this.playlistModel});
  final MyPlaylistModel playlistModel;
  @override
  State<EditPlaylistDialoag> createState() => _EditPlaylistDialoagState();
}

class _EditPlaylistDialoagState extends State<EditPlaylistDialoag> {
  GlobalKey<FormState> formKey = GlobalKey();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? playlistName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPlaylistCubit(),
      child: Dialog(
        backgroundColor: Color.fromARGB(255, 59, 37, 74),
        child: Container(
            margin: EdgeInsets.all(16),
            width: 50,
            child: BlocConsumer<EditPlaylistCubit, EditPlaylistStates>(
              listener: (context, state) {
                if (state is EditPlaylistSuccessState) {
                  BlocProvider.of<PlaylistCubit>(context).fetchPlayLists();
                  Navigator.pop(context);
                } else if (state is EditPlaylistFailureState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.errMsg)));
                }
              },
              builder: (context, state) {
                if (state is EditPlaylistLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return EditPlaylistForm(
                      myPlaylistModel: widget.playlistModel);
                }
              },
            )),
      ),
    );
  }
}
