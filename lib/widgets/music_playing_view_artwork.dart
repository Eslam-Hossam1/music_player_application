import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayingViewArtWork extends StatelessWidget {
  const MusicPlayingViewArtWork({
    super.key,
    required this.songModel,
  });

  final SongModel songModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width - 100,
      width: MediaQuery.of(context).size.width - 100,
      child: QueryArtworkWidget(
        artworkBorder: BorderRadius.circular(16),
        id: songModel.id,
        type: ArtworkType.AUDIO,
        artworkFit: BoxFit.cover,
        size: 512,
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "assets/music_jpeg_4x.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
