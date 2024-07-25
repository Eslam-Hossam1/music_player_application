import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomeSlider extends StatefulWidget {
  const CustomeSlider({
    super.key,
    required this.audioPlayer,
  });
  final AudioPlayer audioPlayer;

  @override
  State<CustomeSlider> createState() => _CustomeSliderState();
}

class _CustomeSliderState extends State<CustomeSlider> {
  Duration duration = const Duration();
  Duration position = const Duration();
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();

    _durationSubscription = widget.audioPlayer.durationStream.listen(
      (event) {
        if (mounted) {
          setState(() {
            if (event != null) {
              duration = event;
            }
          });
        }
      },
    );
    _positionSubscription = widget.audioPlayer.positionStream.listen(
      (event) {
        if (mounted) {
          setState(() {
            position = event;
          });
        }
      },
    );
  }

  // @override
  // void dispose() {
  //   _durationSubscription.cancel();
  //   _positionSubscription.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: position.inSeconds.toDouble(),
          min: const Duration(microseconds: 0).inSeconds.toDouble(),
          max: duration.inSeconds.toDouble(),
          onChanged: (onChanged) {
            changeToSeconds(onChanged.toInt());
            onChanged = onChanged;
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white54,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                position.toString().split('.')[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                duration.toString().split('.')[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
