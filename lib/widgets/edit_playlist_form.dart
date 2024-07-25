import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_cubit.dart';
import 'package:music_player_app/cubits/edit_playlist_cubit/edit_playlist_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/widgets/custome_elevated_button_Icon.dart';

class EditPlaylistForm extends StatefulWidget {
  const EditPlaylistForm({super.key, required this.myPlaylistModel});
  final MyPlaylistModel myPlaylistModel;
  @override
  State<EditPlaylistForm> createState() => _EditPlaylistFormState();
}

class _EditPlaylistFormState extends State<EditPlaylistForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController textEditingController;

  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  String? playListName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController =
        TextEditingController(text: widget.myPlaylistModel.name);
  }

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
              controller: textEditingController,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.edit), hintText: "New Name"),
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
            addHieghtSpace(16),
            CustomeElvatedButtonIcon(
              text: "Edit PlayList",
              iconData: Icons.add_box,
              backgroundColor: Color(0xff30314d),
              internalColor: Colors.white,
              onPresed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  BlocProvider.of<EditPlaylistCubit>(context).editPlaylistName(
                      playlistModel: widget.myPlaylistModel,
                      newName: playListName!);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
