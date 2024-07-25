import 'package:flutter/material.dart';
import 'package:music_player_app/helper/add_space.dart';
import 'package:music_player_app/views/search_view.dart';
import 'package:music_player_app/widgets/bottom_music_container.dart';
import 'package:music_player_app/widgets/custome_icon_button.dart';
import 'package:music_player_app/widgets/custome_text_field.dart';
import 'package:music_player_app/widgets/favourate_songs_list_view.dart';
import 'package:music_player_app/widgets/playlists_tab_bar_view.dart';
import 'package:music_player_app/widgets/songs_list_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: Size(0, 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 0),
                    child: Text(
                      "Make Your Own vibes",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(.4)),
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.only(top: 0, right: 12, left: 12, bottom: 24),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Vibes Player",
                      style: TextStyle(fontSize: 36),
                    ),
                    CustomeIconButton(
                        icon: Icons.search,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SearchView();
                          }));
                        }),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ];
        },
        body: Column(
          children: [
            const TabBar(
                labelStyle: TextStyle(fontSize: 18),
                isScrollable: false,
                indicator: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 3, color: Color(0xff899ccf)))),
                tabs: [
                  Tab(
                    text: "Music",
                  ),
                  Tab(
                    text: "Playlists",
                  ),
                  Tab(
                    text: "Favourates",
                  ),
                ]),
            addHieghtSpace(12),
            Expanded(
                child: Stack(
              children: [
                TabBarView(
                  children: [
                    const SongsListView(),
                    const PlaylistsTabBarView(),
                    const FavourateSongsListView(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: BottomMusicContainer(),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
