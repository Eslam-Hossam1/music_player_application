import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomePlayAndPauseMusicButton extends StatefulWidget {
  const CustomePlayAndPauseMusicButton(
      {super.key, required this.audioPlayer, required this.color});
  final AudioPlayer audioPlayer;
  final Color color;
  @override
  State<CustomePlayAndPauseMusicButton> createState() =>
      _CustomePlayAndPauseMusicButtonState();
}

class _CustomePlayAndPauseMusicButtonState
    extends State<CustomePlayAndPauseMusicButton> {
  bool isPlaying = true;
  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen(
      (state) {
        if (mounted) {
          setState(() {
            isPlaying = state.playing;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isPlaying) {
          widget.audioPlayer.pause();
        } else {
          widget.audioPlayer.play();
        }
      },
      icon: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: widget.color,
        size: 90,
      ),
    );
  }
}
