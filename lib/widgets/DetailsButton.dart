import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/views/music_playing_view.dart';
import 'package:music_player_app/widgets/details_bottom_sheet.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({
    super.key,
    required this.mySongModel,
  });
  final MySongModel mySongModel;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return DetailsBottomSheet(
                  mySongModel: mySongModel,
                );
              });
        },
        icon: Icon(
          Icons.notes,
          size: 30,
        ));
  }
}
