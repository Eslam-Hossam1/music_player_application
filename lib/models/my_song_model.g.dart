// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MySongModelAdapter extends TypeAdapter<MySongModel> {
  @override
  final int typeId = 0;

  @override
  MySongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MySongModel(
      id: fields[0] as int,
      data: fields[1] as String,
      uri: fields[2] as String?,
      displayName: fields[3] as String,
      title: fields[4] as String,
      artist: fields[5] as String?,
      album: fields[6] as String?,
      artworkUri: fields[9] as String?,
      dateAdded: fields[7] as int?,
      isFavourate: fields[8] as bool,
      primaryPaletteColor: fields[10] as PaletteColorHive,
      secondaryPaletteColor: fields[11] as PaletteColorHive,
      artworkString: fields[12] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, MySongModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.uri)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.artist)
      ..writeByte(6)
      ..write(obj.album)
      ..writeByte(7)
      ..write(obj.dateAdded)
      ..writeByte(8)
      ..write(obj.isFavourate)
      ..writeByte(9)
      ..write(obj.artworkUri)
      ..writeByte(10)
      ..write(obj.primaryPaletteColor)
      ..writeByte(11)
      ..write(obj.secondaryPaletteColor)
      ..writeByte(12)
      ..write(obj.artworkString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MySongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaletteColorHiveAdapter extends TypeAdapter<PaletteColorHive> {
  @override
  final int typeId = 1;

  @override
  PaletteColorHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaletteColorHive(
      colorValue: fields[0] as int,
      population: fields[1] as int,
      bodyTextColorValue: fields[2] as int,
      titleTextColorValue: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PaletteColorHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.colorValue)
      ..writeByte(1)
      ..write(obj.population)
      ..writeByte(2)
      ..write(obj.bodyTextColorValue)
      ..writeByte(3)
      ..write(obj.titleTextColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaletteColorHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
