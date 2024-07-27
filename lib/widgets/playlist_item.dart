import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';

class PlaylistItem extends StatefulWidget {
  const PlaylistItem({
    super.key,
    required this.myPlaylistModel,
    this.mySongModel,
  });
  final MyPlaylistModel myPlaylistModel;
  final MySongModel? mySongModel;
  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  @override
  void initState() {
    super.initState();
    if (widget.myPlaylistModel.mysongModelsIdList.isNotEmpty) {}
  }

  MySongModel? getMysongModelFromId(int id) {
    List<MySongModel> songModelList =
        BlocProvider.of<MusicCubit>(context).myPublicSongModelList;
    for (var song in songModelList) {
      if (song.id == id) {
        return song;
      }
    }
    return null;
  }

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
          widget.myPlaylistModel.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Builder(
                builder: (context) {
                  if (widget.myPlaylistModel.mysongModelsIdList.isEmpty) {
                    return Image.asset(
                      "assets/music_jpeg_4x.jpg",
                      fit: BoxFit.cover,
                    );
                  } else {
                    return widget.mySongModel?.artworkString == null
                        ? Image.asset(
                            kApplicationIMage,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            widget.mySongModel!.artworkString!,
                            fit: BoxFit.cover,
                          );
                  }
                },
              )),
        ),
        subtitle: Text(
          overflow: TextOverflow.ellipsis,
          "Songs : ${widget.myPlaylistModel.mysongModelsIdList.length.toString()}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
