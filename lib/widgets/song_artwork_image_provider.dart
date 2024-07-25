import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongArtworkImageProvider extends StatefulWidget {
  final int songId;

  const SongArtworkImageProvider({Key? key, required this.songId})
      : super(key: key);

  @override
  _SongArtworkImageProviderState createState() =>
      _SongArtworkImageProviderState();
}

class _SongArtworkImageProviderState extends State<SongArtworkImageProvider> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  ImageProvider? artworkImageProvider;

  @override
  void initState() {
    super.initState();
    _loadArtwork();
  }

  Future<void> _loadArtwork() async {
    try {
      Uint8List? artworkBytes =
          await audioQuery.queryArtwork(widget.songId, ArtworkType.AUDIO);
      if (artworkBytes != null) {
        setState(() {
          artworkImageProvider = MemoryImage(artworkBytes);
        });
      } else {
        // Handle no artwork found
        setState(() {
          artworkImageProvider = const AssetImage('assets/default_artwork.png');
        });
      }
    } catch (e) {
      // Handle error
      print("Error loading artwork: $e");
      setState(() {
        artworkImageProvider = const AssetImage('assets/default_artwork.png');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return artworkImageProvider != null
        ? Image(image: artworkImageProvider!)
        : const CircularProgressIndicator();
  }
}
