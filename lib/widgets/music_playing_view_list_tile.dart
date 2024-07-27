import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/widgets/custome_favourate_button.dart';

class MusicPlayingViewListTile extends StatelessWidget {
  const MusicPlayingViewListTile({
    super.key,
    required this.mySongModel,
  });

  final MySongModel mySongModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              mySongModel.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(.95),
              ),
            ),
            subtitle: Text(
              mySongModel.artist == "<unknown>"
                  ? mySongModel.title
                  : mySongModel.artist!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(.5),
              ),
            ),
          ),
        ),
        CustomeFavouriteButton(mySongModel: mySongModel),
      ],
    );
  }
}
