import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/constants.dart';
import 'package:music_player_app/cubits/music_cubit/music_cubit_states.dart';
import 'package:music_player_app/models/my_reference_bool.dart';
import 'package:music_player_app/models/my_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';

class MusicCubit extends Cubit<MusicState> {
  OnAudioQuery onAudioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  MyReferenceBool referenceBool = MyReferenceBool();
  List<MySongModel> myPublicSongModelList = [];
  MusicCubit() : super(MusicInitialState()) {
    audioPlayer.setLoopMode(LoopMode.all);
    myPublicSongModelList = fetchMySongModels();
  }

  Future<void> setupSongModels() async {
    if (Hive.box(kFlagBox).get(kOpenedBeforeKey) == false) {
      var mySongModelbox = Hive.box<MySongModel>(kMySongModelBox);
      await mySongModelbox.clear();
      List<SongModel> songModelsList = (await OnAudioQuery().querySongs())
          .where((song) =>
              song.isMusic! &&
              !song.displayName.contains("AUD-") &&
              !(song.title == "tone"))
          .toList();

      final mySongModels =
          await Future.wait(songModelsList.map((songModel) async {
        final artwork =
            await OnAudioQuery().queryArtwork(songModel.id, ArtworkType.AUDIO);

        String? artworkUri;
        if (artwork != null) {
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/${songModel.id}.png')
              .writeAsBytes(artwork);
          artworkUri = file.uri.toString();
        }

        ImageProvider? artworkImageProvider = artwork != null
            ? MemoryImage(artwork)
            : const AssetImage(kApplicationIMage);

        final pg =
            await PaletteGenerator.fromImageProvider(artworkImageProvider!);

        // Try to get a vibrant or muted color before defaulting to purple
        final primaryPaletteColor = pg.darkVibrantColor ??
            pg.darkMutedColor ??
            pg.vibrantColor ??
            PaletteColor(Colors.black, 2);
        final secondaryPaletteColor = pg.lightMutedColor ??
            pg.lightVibrantColor ??
            PaletteColor(Colors.white, 2);

        return MySongModel.fromSongModel(songModel, artworkUri,
            primaryPaletteColor, secondaryPaletteColor, artwork);
      }));

      await mySongModelbox.addAll(mySongModels);
      myPublicSongModelList = fetchMySongModels();
      await Hive.box<int>(kLastSongIdPlayedBox)
          .put(kLastSongIdPlayedKey, mySongModels[0].id);
    }
    await Hive.box(kFlagBox).put(kOpenedBeforeKey, true);
  }

  Future<void> setupAudioPlayer(List<MySongModel> mySongModelList) async {
    List<AudioSource> audioSourceList = [];
    for (var mySongModel in mySongModelList) {
      audioSourceList.add(AudioSource.uri(Uri.parse(mySongModel.uri!),
          tag: MediaItem(
            id: mySongModel.id.toString(),
            album: mySongModel.album,
            title: mySongModel.title,
            artUri: mySongModel.artworkUri != null
                ? Uri.parse(mySongModel.artworkUri!)
                : null,
          )));
    }
    try {
      await audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
    } on PlayerException {
      audioPlayer.stop();
    }
  }

  List<MySongModel> fetchMySongModels() {
    List<MySongModel> mySongModelList =
        Hive.box<MySongModel>(kMySongModelBox).values.toList();
    mySongModelList.sort(
      (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
    );
    return mySongModelList;
  }

  void listenToSongIndex({required AudioPlayer audioplayer}) {
    int x = 1;
    audioplayer.currentIndexStream.listen(
      (event) {
        if (x > 1) {
          emit(MusicInternalChangeCurrentIndexState(
              cubitCurrentIndex: event ?? 0));
        } else {
          x++;
        }
      },
    );
  }

  void listenToExternalSongIndex(
      AudioPlayer audioPlayer, List<MySongModel> songModelList) {
    audioPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        int externalId = songModelList[event].id;
        for (int i = 0; i < myPublicSongModelList.length; i++) {
          if (myPublicSongModelList[i].id == externalId) {
            emit(MusicExternalChangeCurrentIndexState(toBeCurrentIndex: i));
          }
        }
      }
    });
  }

  void stopMainMusicAudio() {
    this.audioPlayer.stop();
    this.referenceBool.isAudioSetted = false;
  }
}
