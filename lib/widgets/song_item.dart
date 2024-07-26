import 'package:flutter/material.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.songModel,
    required this.isActive,
    required this.mySongModel,
  });
  final MySongModel mySongModel;
  final SongModel songModel;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: Colors.grey.shade900.withOpacity(.8),
            blurRadius: 8,
          ),
        ],
        color: const Color(0xff30314d),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          addWidthSpace(12),
          SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: mySongModel.artworkString == null
                  ? Image.asset(
                      kApplicationIMage,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      mySongModel.artworkString!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: // isActive
                  //     ? const EdgeInsets.only(
                  //         top: 16, bottom: 16, left: 12, right: 14)
                  const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 14),
              title: Padding(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                ),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  songModel.title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.blue : null),
                ),
              ),
              subtitle: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .35),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      songModel.artist == "<unknown>"
                          ? songModel.title
                          : songModel.artist!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
