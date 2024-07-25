import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await BlocProvider.of<MusicCubit>(context).setupSongModels();

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const HomeView();
      },
    ));
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
        body: Center(
          child: Text(
            "hello sokkary, wait a minute",
          ),
        ),
      )),
    );
  }
}
