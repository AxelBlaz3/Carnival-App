import 'dart:convert';

import 'package:curate_app/models/movie.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tv.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class TVResponse extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final int? page;

  @JsonKey(name: 'total_pages')
  @HiveField(2)
  final int? totalPages;

  @JsonKey(name: 'tv_shows')
  @HiveField(3)
  List<TV>? tvShows;

  @JsonKey(name: 'is_top_category', defaultValue: false)
  @HiveField(4)
  bool? isTopCategory;

  @JsonKey(name: 'response_title')
  @HiveField(5)
  String? responseTitle;

  @HiveField(6)
  String? genre;

  TVResponse(
      {this.id,
      this.page,
      this.genre,
      this.totalPages,
      this.tvShows,
      this.isTopCategory,
      this.responseTitle});

  factory TVResponse.fromJson(Map<String, dynamic> json) =>
      _$TVResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TVResponseToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class TV {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @JsonKey(name: 'episode_runtime')
  @HiveField(2)
  final int? episodeRuntime;

  @JsonKey(name: 'image_url')
  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final List<dynamic>? genres;

  @JsonKey(name: 'number_of_seasons')
  @HiveField(5)
  final int? numberOfSeasons;

  @JsonKey(name: 'number_of_episodes')
  @HiveField(6)
  final int? numberOfEpisodes;

  @HiveField(7)
  final String? overview;

  @JsonKey(name: 'production_countries')
  @HiveField(8)
  final List<dynamic>? productionCountries;

  @JsonKey(name: 'vote_average')
  @HiveField(9)
  final double? voteAverage;

  @JsonKey(name: 'watch_providers')
  @HiveField(10)
  final dynamic watchProviders;

  @JsonKey(name: 'tmdb_image_base_url')
  @HiveField(11)
  final String? tmdbImageBaseUrl;

  @HiveField(12)
  @JsonKey()
  bool? favorite = false;

  TV copyWith(
      {int? episodeRuntime,
      List<dynamic>? genres,
      int? id,
      String? imageUrl,
      String? name,
      int? numberOfEpisodes,
      int? numberOfSeasons,
      String? overview,
      bool? favorite,
      List<dynamic>? productionCountries,
      double? voteAverage,
      dynamic watchProviders,
      String? tmdbImageBaseUrl}) {
    return TV(
        id: id ?? this.id,
        genres: genres ?? this.genres,
        name: name ?? this.name,
        episodeRuntime: episodeRuntime ?? this.episodeRuntime,
        imageUrl: imageUrl ?? this.imageUrl,
        numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
        numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
        overview: overview ?? this.overview,
        favorite: favorite ?? this.favorite,
        productionCountries: productionCountries ?? this.productionCountries,
        voteAverage: voteAverage ?? this.voteAverage,
        watchProviders: watchProviders ?? this.watchProviders,
        tmdbImageBaseUrl: tmdbImageBaseUrl ?? this.tmdbImageBaseUrl);
  }

  // bool operator ==(other) {
  //   if (other == null || other is !TV) return false;

  //   return id == other.id!;
  // }

  get getIsFavorite => this.favorite ?? false;

  TV(
      {this.episodeRuntime,
      this.genres,
      this.id,
      this.imageUrl,
      this.name,
      this.numberOfEpisodes,
      this.numberOfSeasons,
      this.overview,
      this.favorite,
      this.productionCountries,
      this.voteAverage,
      this.watchProviders,
      this.tmdbImageBaseUrl});

  factory TV.fromJson(Map<String, dynamic> json) => _$TVFromJson(json);

  Map<String, dynamic> toJson() => _$TVToJson(this);
}
