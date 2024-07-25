import 'package:flutter/material.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.songModel,
    required this.isActive,
  });
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
              child: QueryArtworkWidget(
                id: songModel.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                artworkBorder: BorderRadius.circular(0),
                keepOldArtwork: true,
                nullArtworkWidget: Image.asset(
                  "assets/music_jpeg_4x.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: isActive
                  ? const EdgeInsets.only(
                      top: 16, bottom: 16, left: 12, right: 14)
                  : const EdgeInsets.only(
                      top: 8, bottom: 8, left: 12, right: 14),
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
                  addWidthSpace(10),
                  const SizedBox(
                    width: 10,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "-",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  addWidthSpace(10),
                  const SizedBox(
                    width: 40,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "3:24",
                      style: TextStyle(fontSize: 14),
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
