import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_song_model.dart';

class DetailsBottomSheet extends StatelessWidget {
  const DetailsBottomSheet({
    super.key,
    required this.mySongModel,
  });
  final MySongModel mySongModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                "Title :",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          Text(
            mySongModel.title,
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            "Artist : ",
            style: TextStyle(fontSize: 24),
          ),
          Text(
            mySongModel.artist == "<unknown>"
                ? mySongModel.title
                : mySongModel.artist!,
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            "Album : ",
            style: TextStyle(fontSize: 24),
          ),
          Text(
            mySongModel.album ?? "unknown",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
