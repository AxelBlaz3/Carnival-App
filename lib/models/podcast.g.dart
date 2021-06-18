// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PodcastResponseAdapter extends TypeAdapter<PodcastResponse> {
  @override
  final int typeId = 7;

  @override
  PodcastResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PodcastResponse(
      fiveMinpodcasts: (fields[6] as List?)?.cast<dynamic>(),
      tenMinpodcasts: (fields[10] as List?)?.cast<dynamic>(),
      fifteenMinpodcasts: (fields[11] as List?)?.cast<dynamic>(),
      twentyMinpodcasts: (fields[12] as List?)?.cast<dynamic>(),
      genre: fields[9] as String?,
      averageRuntime: fields[5] as int?,
      totalRuntime: fields[4] as int?,
      responseTitle: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PodcastResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(4)
      ..write(obj.totalRuntime)
      ..writeByte(5)
      ..write(obj.averageRuntime)
      ..writeByte(6)
      ..write(obj.fiveMinpodcasts)
      ..writeByte(8)
      ..write(obj.responseTitle)
      ..writeByte(9)
      ..write(obj.genre)
      ..writeByte(10)
      ..write(obj.tenMinpodcasts)
      ..writeByte(11)
      ..write(obj.fifteenMinpodcasts)
      ..writeByte(12)
      ..write(obj.twentyMinpodcasts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PodcastResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PodcastAdapter extends TypeAdapter<Podcast> {
  @override
  final int typeId = 8;

  @override
  Podcast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Podcast(
      id: fields[0] as String?,
      description: fields[4] as String?,
      externalUrl: fields[6] as dynamic,
      images: (fields[2] as List?)?.cast<dynamic>(),
      name: fields[3] as String?,
      favorite: fields[7] as bool?,
      totalEpisodes: fields[1] as int?,
      totalRuntime: fields[5] as int?,
      averageRuntime: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Podcast obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalEpisodes)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.totalRuntime)
      ..writeByte(6)
      ..write(obj.externalUrl)
      ..writeByte(7)
      ..write(obj.favorite)
      ..writeByte(8)
      ..write(obj.averageRuntime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PodcastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PodcastImageAdapter extends TypeAdapter<PodcastImage> {
  @override
  final int typeId = 9;

  @override
  PodcastImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PodcastImage(
      height: fields[0] as int?,
      width: fields[1] as int?,
      url: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PodcastImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.height)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PodcastImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastResponse _$PodcastResponseFromJson(Map<String, dynamic> json) {
  return PodcastResponse(
    fiveMinpodcasts: json['five_min'] as List<dynamic>?,
    tenMinpodcasts: json['ten_min'] as List<dynamic>?,
    fifteenMinpodcasts: json['fifteen_min'] as List<dynamic>?,
    twentyMinpodcasts: json['twenty_min'] as List<dynamic>?,
    genre: json['genre'] as String?,
    averageRuntime: json['avg_runtime'] as int?,
    totalRuntime: json['total_runtime'] as int?,
    responseTitle: json['response_title'] as String? ?? '',
  );
}

Map<String, dynamic> _$PodcastResponseToJson(PodcastResponse instance) =>
    <String, dynamic>{
      'total_runtime': instance.totalRuntime,
      'avg_runtime': instance.averageRuntime,
      'five_min': instance.fiveMinpodcasts,
      'response_title': instance.responseTitle,
      'genre': instance.genre,
      'ten_min': instance.tenMinpodcasts,
      'fifteen_min': instance.fifteenMinpodcasts,
      'twenty_min': instance.twentyMinpodcasts,
    };

Podcast _$PodcastFromJson(Map<String, dynamic> json) {
  return Podcast(
    id: json['id'] as String?,
    description: json['description'] as String?,
    externalUrl: json['external_urls'],
    images: json['images'] as List<dynamic>?,
    name: json['name'] as String?,
    favorite: json['favorite'] as bool?,
    totalEpisodes: json['total_episodes'] as int?,
    totalRuntime: json['total_runtime'] as int?,
    averageRuntime: json['avg_runtime'] as int?,
  );
}

Map<String, dynamic> _$PodcastToJson(Podcast instance) => <String, dynamic>{
      'id': instance.id,
      'total_episodes': instance.totalEpisodes,
      'images': instance.images,
      'name': instance.name,
      'description': instance.description,
      'total_runtime': instance.totalRuntime,
      'external_urls': instance.externalUrl,
      'favorite': instance.favorite,
      'avg_runtime': instance.averageRuntime,
    };

PodcastImage _$PodcastImageFromJson(Map<String, dynamic> json) {
  return PodcastImage(
    height: json['height'] as int?,
    width: json['width'] as int?,
    url: json['url'] as String?,
  );
}

Map<String, dynamic> _$PodcastImageToJson(PodcastImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'url': instance.url,
    };
