import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ShuffleButton extends StatefulWidget {
  const ShuffleButton({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  late bool isShuffle;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShuffle = widget.audioPlayer.shuffleModeEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (isShuffle) {
            widget.audioPlayer.setShuffleModeEnabled(false);
            isShuffle = !isShuffle;
            setState(() {});
          } else {
            widget.audioPlayer.setShuffleModeEnabled(true);
            isShuffle = !isShuffle;
            setState(() {});
          }
        },
        icon: Icon(
          isShuffle ? Icons.shuffle : Icons.repeat_rounded,
          size: 30,
        ));
  }
}
