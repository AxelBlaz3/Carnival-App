// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TVResponseAdapter extends TypeAdapter<TVResponse> {
  @override
  final int typeId = 0;

  @override
  TVResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TVResponse(
      id: fields[0] as int?,
      page: fields[1] as int?,
      genre: fields[6] as String?,
      totalPages: fields[2] as int?,
      tvShows: (fields[3] as List?)?.cast<TV>(),
      isTopCategory: fields[4] as bool?,
      responseTitle: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TVResponse obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.page)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.tvShows)
      ..writeByte(4)
      ..write(obj.isTopCategory)
      ..writeByte(5)
      ..write(obj.responseTitle)
      ..writeByte(6)
      ..write(obj.genre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TVAdapter extends TypeAdapter<TV> {
  @override
  final int typeId = 1;

  @override
  TV read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TV(
      episodeRuntime: fields[2] as int?,
      genres: (fields[4] as List?)?.cast<dynamic>(),
      id: fields[0] as int?,
      imageUrl: fields[3] as String?,
      name: fields[1] as String?,
      numberOfEpisodes: fields[6] as int?,
      numberOfSeasons: fields[5] as int?,
      overview: fields[7] as String?,
      favorite: fields[12] as bool?,
      productionCountries: (fields[8] as List?)?.cast<dynamic>(),
      voteAverage: fields[9] as double?,
      watchProviders: fields[10] as dynamic,
      tmdbImageBaseUrl: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TV obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.episodeRuntime)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.numberOfSeasons)
      ..writeByte(6)
      ..write(obj.numberOfEpisodes)
      ..writeByte(7)
      ..write(obj.overview)
      ..writeByte(8)
      ..write(obj.productionCountries)
      ..writeByte(9)
      ..write(obj.voteAverage)
      ..writeByte(10)
      ..write(obj.watchProviders)
      ..writeByte(11)
      ..write(obj.tmdbImageBaseUrl)
      ..writeByte(12)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TVResponse _$TVResponseFromJson(Map<String, dynamic> json) {
  return TVResponse(
    id: json['id'] as int?,
    page: json['page'] as int?,
    genre: json['genre'] as String?,
    totalPages: json['total_pages'] as int?,
    tvShows: (json['tv_shows'] as List<dynamic>?)
        ?.map((e) => TV.fromJson(e as Map<String, dynamic>))
        .toList(),
    isTopCategory: json['is_top_category'] as bool? ?? false,
    responseTitle: json['response_title'] as String?,
  );
}

Map<String, dynamic> _$TVResponseToJson(TVResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
      'total_pages': instance.totalPages,
      'tv_shows': instance.tvShows,
      'is_top_category': instance.isTopCategory,
      'response_title': instance.responseTitle,
      'genre': instance.genre,
    };

TV _$TVFromJson(Map<String, dynamic> json) {
  return TV(
    episodeRuntime: json['episode_runtime'] as int?,
    genres: json['genres'] as List<dynamic>?,
    id: json['id'] as int?,
    imageUrl: json['image_url'] as String?,
    name: json['name'] as String?,
    numberOfEpisodes: json['number_of_episodes'] as int?,
    numberOfSeasons: json['number_of_seasons'] as int?,
    overview: json['overview'] as String?,
    favorite: json['favorite'] as bool?,
    productionCountries: json['production_countries'] as List<dynamic>?,
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    watchProviders: json['watch_providers'],
    tmdbImageBaseUrl: json['tmdb_image_base_url'] as String?,
  );
}

Map<String, dynamic> _$TVToJson(TV instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'episode_runtime': instance.episodeRuntime,
      'image_url': instance.imageUrl,
      'genres': instance.genres,
      'number_of_seasons': instance.numberOfSeasons,
      'number_of_episodes': instance.numberOfEpisodes,
      'overview': instance.overview,
      'production_countries': instance.productionCountries,
      'vote_average': instance.voteAverage,
      'watch_providers': instance.watchProviders,
      'tmdb_image_base_url': instance.tmdbImageBaseUrl,
      'favorite': instance.favorite,
    };
