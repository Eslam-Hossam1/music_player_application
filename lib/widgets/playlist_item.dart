import 'package:flutter/material.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/views/playlist_view.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    super.key,
    required this.myPlaylistModel,
  });
  final MyPlaylistModel myPlaylistModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          overflow: TextOverflow.ellipsis,
          myPlaylistModel.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Hero(
            tag: "lol2",
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Builder(
                  builder: (context) {
                    if (myPlaylistModel.mysongModelsIdList.isEmpty) {
                      return Image.asset(
                        "assets/music_jpeg_4x.jpg",
                        fit: BoxFit.cover,
                      );
                    } else {
                      return QueryArtworkWidget(
                        id: myPlaylistModel.mysongModelsIdList[0],
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(0),
                        nullArtworkWidget: Image.asset(
                          "assets/music_jpeg_4x.jpg",
                          fit: BoxFit.cover,
                        ),
                        keepOldArtwork: true,
                      );
                    }
                  },
                )),
          ),
        ),
        subtitle: Text(
          overflow: TextOverflow.ellipsis,
          "Songs : ${myPlaylistModel.mysongModelsIdList.length.toString()}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
