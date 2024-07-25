import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';

class AddPlayListForm extends StatefulWidget {
  const AddPlayListForm({
    super.key,
  });

  @override
  State<AddPlayListForm> createState() => _AddPlayListFormState();
}

class _AddPlayListFormState extends State<AddPlayListForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  String? playListName;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.add), hintText: "Playlist Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "this field requrid";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                playListName = newValue;
              },
            ),
            addHieghtSpace(40),
            CustomeElvatedButtonIcon(
              text: "Add PlayList",
              iconData: Icons.add_box,
              backgroundColor: Color(0xff30314d),
              internalColor: Colors.white,
              onPresed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  BlocProvider.of<AddAndDeletePlaylistCubit>(context)
                      .addPlayList(name: playListName!);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
