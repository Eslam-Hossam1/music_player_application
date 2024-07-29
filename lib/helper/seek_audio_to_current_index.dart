import 'package:just_audio/just_audio.dart';

Future<void> seekAudioToCurrenIndex(int index, AudioPlayer audioPlayer) async {
  await audioPlayer.seek(Duration.zero, index: index);
}
