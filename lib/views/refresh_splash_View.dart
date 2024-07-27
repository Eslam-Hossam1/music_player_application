import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/helper/handle_add_delete_audio_files.dart';
import 'package:music_player_app/views/home_view.dart';

class RefreshSplashView extends StatefulWidget {
  const RefreshSplashView({super.key, required this.msgStr});
  final String msgStr;
  @override
  State<RefreshSplashView> createState() => _RefreshSplashViewState();
}

class _RefreshSplashViewState extends State<RefreshSplashView> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await Hive.box(kFlagBox).put(kOpenedBeforeKey, false);
    if (widget.msgStr == "add") {
      await handleSongsAdded().then((e) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          },
        ));
      });
    } else if (widget.msgStr == "delete") {
      await handleSongsRemoved().then((e) async {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          },
        ));
      });
    } else {
      await BlocProvider.of<MusicCubit>(context).setupSongModels().then(
        (value) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const HomeView();
            },
          ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2A0632),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          children: [
            Image.asset(kApplicationIMage),
            addHieghtSpace(32),
            const Text("Refresh Audio Files, Please wait")
          ],
        )),
      )),
    );
  }
}
