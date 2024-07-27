import 'package:flutter/material.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/models/my_song_model.dart';

class MusicPlayingViewArtWork extends StatelessWidget {
  const MusicPlayingViewArtWork({
    super.key,
    required this.mySongModel,
  });

  final MySongModel mySongModel;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "lol",
      child: SizedBox(
        height: MediaQuery.of(context).size.width - 100,
        width: MediaQuery.of(context).size.width - 100,
        child: mySongModel.artworkString == null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  kApplicationIMage,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  mySongModel.artworkString!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
