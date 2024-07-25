import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CheckboxSongItem extends StatelessWidget {
  const CheckboxSongItem(
      {super.key, required this.songModel, required this.isChecked});
  final SongModel songModel;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Stack(
        children: [
          SongItem(songModel: songModel, isActive: false),
          Positioned(
            right: 0,
            child: Icon(isChecked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank),
          ),
        ],
      ),
    );
  }
}
