import 'package:hive_flutter/hive_flutter.dart';

part 'my_playlist_model.g.dart';

@HiveType(typeId: 2)
class MyPlaylistModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  final List<int> mysongModelsIdList;

  MyPlaylistModel({required this.name, required this.mysongModelsIdList});
}
