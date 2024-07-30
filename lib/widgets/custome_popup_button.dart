import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/views/add_songs_to_playlist_view.dart';
import 'package:music_player_app/views/delete_songs_from_playlist_view.dart';
import 'package:music_player_app/views/playlist_view.dart';

class CustomePopupMenuButton extends StatelessWidget {
  const CustomePopupMenuButton({
    super.key,
    required this.widget,
  });

  final PlaylistView widget;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Add Songs"), Icon(Icons.add_box_outlined)],
            ),
            onTap: () {
              if (widget.myPlaylistModel.mysongModelsIdList.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("you don't have songs in your device")));
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddSongsToPlaylistView(
                      myPlaylistModel: widget.myPlaylistModel,
                    );
                  },
                ));
              }
            },
          ),
          PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Delete Songs"),
                  Icon(CupertinoIcons.delete_simple)
                ],
              ),
              onTap: () {
                if (widget.myPlaylistModel.mysongModelsIdList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text("you don't have songs in the playlist")));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DeleteSongsFromPlaylistView(
                          myPlaylistModel: widget.myPlaylistModel,
                        );
                      },
                    ),
                  );
                }
              })
        ];
      },
    );
  }
}
