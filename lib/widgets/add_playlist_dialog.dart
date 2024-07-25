import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_cubit.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_states.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/widgets/add_playlist_form.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';

class AddPlaylistDialoag extends StatefulWidget {
  const AddPlaylistDialoag({
    super.key,
  });

  @override
  State<AddPlaylistDialoag> createState() => _AddPlaylistDialoagState();
}

class _AddPlaylistDialoagState extends State<AddPlaylistDialoag> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAndDeletePlaylistCubit(),
      child: Dialog(
        backgroundColor: Color.fromARGB(255, 59, 37, 74),
        child: Container(
            margin: EdgeInsets.all(16),
            height: 150,
            width: 50,
            child: BlocConsumer<AddAndDeletePlaylistCubit,
                AddAndDeletePlaylistStates>(
              listener: (context, state) {
                if (state is AddAndDeletePlaylistSuccessState) {
                  BlocProvider.of<PlaylistCubit>(context).fetchPlayLists();
                  Navigator.pop(context);
                } else if (state is AddAndDeletePlaylistFailureState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.errMsg)));
                }
              },
              builder: (context, state) {
                if (state is AddAndDeletePlaylistLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return AddPlayListForm();
                }
              },
            )),
      ),
    );
  }
}
