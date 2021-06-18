import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class MovieResponse extends HiveObject {
  @HiveField(0)
  final int? page;
  @HiveField(1)
  final int? id;

  @JsonKey(name: 'total_pages')
  @HiveField(2)
  final int? totalPages;

  @HiveField(3)
  List<Movie>? movies;

  @JsonKey(name: 'avg_runtime')
  @HiveField(4)
  final int? averageRuntime;

  @JsonKey(defaultValue: false)
  @HiveField(5)
  bool? isTopCategory;

  @HiveField(6)
  String? responseTitle;

  @HiveField(7)
  String? genre;

  MovieResponse(
      {this.id,
      this.page,
      this.totalPages,
      this.movies,
      this.genre,
      this.averageRuntime,
      this.isTopCategory,
      this.responseTitle});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 5)
class Movie {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;

  @HiveField(2)
  final List<dynamic>? genres;
  @HiveField(3)
  final int? runtime;

  @JsonKey(name: 'vote_average')
  @HiveField(4)
  final double? voteAverage;
  @HiveField(5)
  final String? overview;
  @HiveField(6)
  final String? homepage;

  @JsonKey(name: 'production_countries')
  @HiveField(7)
  final List<dynamic>? productionCountries;

  @JsonKey(name: 'image_url')
  @HiveField(8)
  final String? imageUrl;

  @JsonKey(name: 'watch_providers')
  @HiveField(9)
  final dynamic watchProviders;

  @JsonKey(name: 'tmdb_image_base_url')
  @HiveField(10)
  final String? tmdbImageBaseUrl;

  @HiveField(11)
  @JsonKey()
  bool? favorite = false;

  get getIsFavorite => this.favorite ?? false;

  Movie copyWith(
      {int? id,
      String? title,
      List<dynamic>? genres,
      String? homepage,
      String? overview,
      List<dynamic>? productionCountries,
      int? runtime,
      double? voteAverage,
      String? imageUrl,
      bool? favorite,
      dynamic watchProviders,
      String? tmdbImageBaseUrl}) {
    return Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        genres: genres ?? this.genres,
        homepage: homepage ?? this.homepage,
        overview: overview ?? this.overview,
        productionCountries: productionCountries ?? this.productionCountries,
        runtime: runtime ?? this.runtime,
        voteAverage: voteAverage ?? this.voteAverage,
        imageUrl: imageUrl ?? this.imageUrl,
        favorite: favorite ?? this.favorite,
        watchProviders: watchProviders ?? this.watchProviders,
        tmdbImageBaseUrl: tmdbImageBaseUrl ?? this.tmdbImageBaseUrl);
  }

  Movie(
      {this.id,
      this.title,
      this.genres,
      this.homepage,
      this.overview,
      this.productionCountries,
      this.runtime,
      this.voteAverage,
      this.imageUrl,
      this.favorite,
      this.watchProviders,
      this.tmdbImageBaseUrl});

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class Genre {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 3)
class ProductionCountry {
  @HiveField(0)
  final String? region;
  @HiveField(1)
  final String? name;

  const ProductionCountry({required this.region, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 4)
class WatchProvider {
  @HiveField(0)
  final dynamic providerMetaData;

  @HiveField(1)
  final String? link;

  const WatchProvider({this.link, this.providerMetaData});

  factory WatchProvider.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProviderToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 10)
class ProviderMetaData {
  @JsonKey(name: 'provider_id')
  @HiveField(0)
  final int? providerId;

  @HiveField(1)
  @JsonKey(name: 'provider_name')
  final String? name;

  @JsonKey(name: 'logo_path')
  @HiveField(2)
  final String? logoPath;

  const ProviderMetaData({this.providerId, this.logoPath, this.name});

  factory ProviderMetaData.fromJson(Map<String, dynamic> json) =>
      _$ProviderMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderMetaDataToJson(this);
}
