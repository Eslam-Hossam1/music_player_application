import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:music_player_app/helper/check_is_audio.dart';
import 'package:music_player_app/views/refresh_splash_View.dart';
import 'package:music_player_app/widgets/home_view_body.dart';
import 'package:watcher/watcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _startIsolate();
  }

  void _startIsolate() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_watchFiles, receivePort.sendPort);

    receivePort.listen((message) {
      String msgStr = message;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RefreshSplashView(
                    msgStr: msgStr,
                  )),
        );
      }
    });
  }

  static void _watchFiles(SendPort sendPort) async {
    // Watch directories
    final List<String> directories = [
      '/storage/emulated/0/Download',
      '/storage/emulated/0/snaptube'
    ];

    for (final dir in directories) {
      final watcher = DirectoryWatcher(dir);
      watcher.events.listen((event) {
        if (event.type == ChangeType.ADD ||
            event.type == ChangeType.MODIFY ||
            event.type == ChangeType.REMOVE) {
          if (isAudioFile(event.path)) {
            if (event.type == ChangeType.ADD) {
              sendPort.send("add");
            } else if (event.type == ChangeType.MODIFY) {
              sendPort.send("modify");
            } else if (event.type == ChangeType.REMOVE) {
              sendPort.send("delete");
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xff303151).withOpacity(0.6),
            const Color(0xff303151).withOpacity(0.9),
            Colors.purple,
          ])),
      child: const SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: HomeViewBody(),
        ),
      ),
    );
  }
}
