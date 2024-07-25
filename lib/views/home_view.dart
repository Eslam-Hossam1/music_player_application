import 'package:flutter/material.dart';
import 'package:music_player_app/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const id = "HomeView";
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
