import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 10)
class User {
  @HiveField(0)
  @JsonKey(required: true, name: "_id")
  final String? id;

  @HiveField(1)
  @JsonKey(required: true)
  final String? email;

  @HiveField(2)
  @JsonKey(name: 'workout_length')
  int? workoutLength = 20;

  @HiveField(3)
  @JsonKey(name: 'podcast_genres')
  List<String>? podcastGenres = [];

  @HiveField(4)
  @JsonKey(name: "movie_genre_ids")
  List<String>? movieGenreIds = [];

  @HiveField(5)
  @JsonKey(name: "tv_genre_ids")
  List<String>? tvGenreIds;

  @HiveField(6)
  @JsonKey(name: "watch_provider_ids")
  List<String>? watchProviderIds = [];

  @HiveField(7)
  @JsonKey(name: "access_token")
  String? accessToken;

  @HiveField(8)
  @JsonKey(name: "refresh_token")
  String? refreshToken;

  @HiveField(9)
  @JsonKey(name: "is_podcasts_checked")
  bool? isPodcastsChecked;

  @HiveField(10)
  @JsonKey(name: "is_movies_checked")
  bool? isMoviesChecked;

  @HiveField(11)
  @JsonKey(name: "is_tv_checked")
  bool? isTvChecked;

  @HiveField(12)
  @JsonKey(defaultValue: true)
  bool? isTVFilterChecked;

  @HiveField(13)
  @JsonKey(defaultValue: true)
  bool? isMovieFilterChecked;

  @HiveField(14)
  @JsonKey(defaultValue: true)
  bool? isPodcastFilterChecked;

  @HiveField(15)
  @JsonKey()
  dynamic favorites;

  @HiveField(16)
  @JsonKey(name: 'access_token_expires_in')
  int? accessTokenExpiresIn;

  @HiveField(17)
  @JsonKey(name: 'access_token_created_at')
  DateTime? accessTokenCreatedAt;

  get getFavorites =>
      this.favorites ?? {"movies": [], "podcasts": [], "shows": []};

  User(
      {this.id,
      this.email,
      this.workoutLength,
      this.movieGenreIds,
      this.isPodcastsChecked,
      this.isMoviesChecked,
      this.isTvChecked,
      this.isPodcastFilterChecked,
      this.isTVFilterChecked,
      this.isMovieFilterChecked,
      this.podcastGenres,
      this.tvGenreIds,
      this.watchProviderIds,
      this.favorites,
      this.accessToken,
      this.accessTokenExpiresIn,
      this.accessTokenCreatedAt,
      this.refreshToken});

  String get getId => this.id ?? "";

  int get getWorkoutLength => this.workoutLength ?? 20;

  String get getEmail => this.email ?? "";

  String get getAccessToken => this.accessToken ?? "";

  String get getRefreshToken => this.refreshToken ?? "";

  bool get getIsMoviesChecked => this.isMoviesChecked ?? false;

  bool get getIsTvChecked => this.isTvChecked ?? false;

  bool get getIsPodcastsChecked => this.isPodcastsChecked ?? false;

  bool get getIsMoviesFilterChecked => this.isMovieFilterChecked ?? true;

  bool get getIsTvFilterChecked => this.isTVFilterChecked ?? true;

  bool get getIsPodcastsFilterChecked => this.isPodcastFilterChecked ?? true;

  List<String> get getMovieGenreIds => this.movieGenreIds ?? <String>[];

  List<String> get getTvGenreIds => this.tvGenreIds ?? <String>[];

  List<String> get getPodcastGenres => this.podcastGenres ?? <String>[];

  List<String> get getWatchProviderIds => this.watchProviderIds ?? <String>[];

  String getFormattedListForDB(List anyList) =>
      anyList != null ? anyList.join('|') : '';

  int getFormattedBoolForDB(bool value) => value != null ? (value ? 1 : 0) : 0;

  User copyWith(
      {String? id,
      String? email,
      int? workoutLength,
      bool? isPodcastsChecked,
      bool? isMoviesChecked,
      bool? isTvChecked,
      bool? isTvFilterChecked,
      bool? isMovieFilterChecked,
      bool? isPodcastFilterChecked,
      List<String>? movieGenreIds,
      List<String>? seriesGenreIds,
      List<String>? podcastGenres,
      List<String>? watchProviderIds,
      dynamic favorites,
      String? accessToken,
      String? refreshToken,
      int? accessTokenExpiresIn,
      DateTime? accessTokenCreatedAt}) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        workoutLength: workoutLength ?? this.workoutLength,
        isPodcastsChecked: isPodcastsChecked ?? this.isPodcastsChecked,
        isMoviesChecked: isMoviesChecked ?? this.isMoviesChecked,
        isTvChecked: isTvChecked ?? this.isTvChecked,
        isPodcastFilterChecked:
            isPodcastFilterChecked ?? this.isPodcastFilterChecked,
        isMovieFilterChecked: isMovieFilterChecked ?? this.isMovieFilterChecked,
        isTVFilterChecked: isTvFilterChecked ?? this.isTVFilterChecked,
        podcastGenres: podcastGenres ?? this.podcastGenres,
        movieGenreIds: movieGenreIds ?? this.movieGenreIds,
        tvGenreIds: seriesGenreIds ?? this.tvGenreIds,
        watchProviderIds: watchProviderIds ?? this.watchProviderIds,
        favorites: favorites ?? this.favorites,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        accessTokenExpiresIn: accessTokenExpiresIn ?? this.accessTokenExpiresIn,
        accessTokenCreatedAt:
            accessTokenCreatedAt ?? this.accessTokenCreatedAt);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
