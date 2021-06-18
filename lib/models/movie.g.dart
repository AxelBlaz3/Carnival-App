// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieResponseAdapter extends TypeAdapter<MovieResponse> {
  @override
  final int typeId = 6;

  @override
  MovieResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieResponse(
      id: fields[1] as int?,
      page: fields[0] as int?,
      totalPages: fields[2] as int?,
      movies: (fields[3] as List?)?.cast<Movie>(),
      genre: fields[7] as String?,
      averageRuntime: fields[4] as int?,
      isTopCategory: fields[5] as bool?,
      responseTitle: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.movies)
      ..writeByte(4)
      ..write(obj.averageRuntime)
      ..writeByte(5)
      ..write(obj.isTopCategory)
      ..writeByte(6)
      ..write(obj.responseTitle)
      ..writeByte(7)
      ..write(obj.genre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 5;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as int?,
      title: fields[1] as String?,
      genres: (fields[2] as List?)?.cast<dynamic>(),
      homepage: fields[6] as String?,
      overview: fields[5] as String?,
      productionCountries: (fields[7] as List?)?.cast<dynamic>(),
      runtime: fields[3] as int?,
      voteAverage: fields[4] as double?,
      imageUrl: fields[8] as String?,
      favorite: fields[11] as bool?,
      watchProviders: fields[9] as dynamic,
      tmdbImageBaseUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.genres)
      ..writeByte(3)
      ..write(obj.runtime)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.overview)
      ..writeByte(6)
      ..write(obj.homepage)
      ..writeByte(7)
      ..write(obj.productionCountries)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.watchProviders)
      ..writeByte(10)
      ..write(obj.tmdbImageBaseUrl)
      ..writeByte(11)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final int typeId = 2;

  @override
  Genre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Genre(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Genre obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductionCountryAdapter extends TypeAdapter<ProductionCountry> {
  @override
  final int typeId = 3;

  @override
  ProductionCountry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionCountry(
      region: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionCountry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.region)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionCountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchProviderAdapter extends TypeAdapter<WatchProvider> {
  @override
  final int typeId = 4;

  @override
  WatchProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProvider(
      link: fields[1] as String?,
      providerMetaData: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, WatchProvider obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.providerMetaData)
      ..writeByte(1)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProviderMetaDataAdapter extends TypeAdapter<ProviderMetaData> {
  @override
  final int typeId = 10;

  @override
  ProviderMetaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderMetaData(
      providerId: fields[0] as int?,
      logoPath: fields[2] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderMetaData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.providerId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderMetaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) {
  return MovieResponse(
    id: json['id'] as int?,
    page: json['page'] as int?,
    totalPages: json['total_pages'] as int?,
    movies: (json['movies'] as List<dynamic>?)
        ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList(),
    genre: json['genre'] as String?,
    averageRuntime: json['avg_runtime'] as int?,
    isTopCategory: json['isTopCategory'] as bool? ?? false,
    responseTitle: json['responseTitle'] as String?,
  );
}

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'id': instance.id,
      'total_pages': instance.totalPages,
      'movies': instance.movies,
      'avg_runtime': instance.averageRuntime,
      'isTopCategory': instance.isTopCategory,
      'responseTitle': instance.responseTitle,
      'genre': instance.genre,
    };

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['id'] as int?,
    title: json['title'] as String?,
    genres: json['genres'] as List<dynamic>?,
    homepage: json['homepage'] as String?,
    overview: json['overview'] as String?,
    productionCountries: json['production_countries'] as List<dynamic>?,
    runtime: json['runtime'] as int?,
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    imageUrl: json['image_url'] as String?,
    favorite: json['favorite'] as bool?,
    watchProviders: json['watch_providers'],
    tmdbImageBaseUrl: json['tmdb_image_base_url'] as String?,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'genres': instance.genres,
      'runtime': instance.runtime,
      'vote_average': instance.voteAverage,
      'overview': instance.overview,
      'homepage': instance.homepage,
      'production_countries': instance.productionCountries,
      'image_url': instance.imageUrl,
      'watch_providers': instance.watchProviders,
      'tmdb_image_base_url': instance.tmdbImageBaseUrl,
      'favorite': instance.favorite,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) {
  return Genre(
    id: json['id'] as int?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) {
  return ProductionCountry(
    region: json['region'] as String?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$ProductionCountryToJson(ProductionCountry instance) =>
    <String, dynamic>{
      'region': instance.region,
      'name': instance.name,
    };

WatchProvider _$WatchProviderFromJson(Map<String, dynamic> json) {
  return WatchProvider(
    link: json['link'] as String?,
    providerMetaData: json['providerMetaData'],
  );
}

Map<String, dynamic> _$WatchProviderToJson(WatchProvider instance) =>
    <String, dynamic>{
      'providerMetaData': instance.providerMetaData,
      'link': instance.link,
    };

ProviderMetaData _$ProviderMetaDataFromJson(Map<String, dynamic> json) {
  return ProviderMetaData(
    providerId: json['provider_id'] as int?,
    logoPath: json['logo_path'] as String?,
    name: json['provider_name'] as String?,
  );
}

Map<String, dynamic> _$ProviderMetaDataToJson(ProviderMetaData instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'provider_name': instance.name,
      'logo_path': instance.logoPath,
    };
