import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/add_and_delete_playlist_cubit/add_and_delete_playlist_cubit.dart';
import 'package:music_player_app/cubits/crud_playlist_songs_cubit/crud_playlist_songs_cubit.dart';
import 'package:music_player_app/cubits/bottom_music_container_cubit/bottom_music_container_cubit.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit.dart';
import 'package:music_player_app/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_player_app/helper/check_device_crud_files.dart';
import 'package:music_player_app/helper/request_permissions.dart';
import 'package:music_player_app/models/my_playlist_model.dart';
import 'package:music_player_app/models/my_song_model.dart';

import 'package:music_player_app/views/splash_view.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();

  Hive.registerAdapter(MySongModelAdapter());
  Hive.registerAdapter(PaletteColorHiveAdapter());
  Hive.registerAdapter(MyPlaylistModelAdapter());
  await Hive.openBox<MySongModel>(kMySongModelBox);
  await Hive.openBox<int>(kLastSongIdPlayedBox);
  await Hive.openBox<MyPlaylistModel>('myPlaylistModelBox');
  await Hive.openBox(kFlagBox);
  await requestPermissions();
  if (Hive.box(kFlagBox).get(kOpenedBeforeKey) == null) {
    await Hive.box(kFlagBox).put(kOpenedBeforeKey, false);
  } else {
    bool needToSetUp = await checkChangeOccuredInDeviceSongsFiles();
    await Hive.box(kFlagBox).put(kOpenedBeforeKey, !needToSetUp);
  }
  runApp(const MusicApp());
}

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MusicCubit(),
        ),
        BlocProvider(
          create: (context) => FavourateSongsCubit(),
        ),
        BlocProvider(create: (context) => PlaylistCubit()),
        BlocProvider(create: (context) => CrudPlaylistSongsCubit()),
        BlocProvider(create: (context) => AddAndDeletePlaylistCubit()),
        BlocProvider(create: (context) => BottomMusicContainerCubit())
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
      ),
    );
  }
}
