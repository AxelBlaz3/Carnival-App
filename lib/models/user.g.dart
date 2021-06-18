// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 10;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String?,
      email: fields[1] as String?,
      workoutLength: fields[2] as int?,
      movieGenreIds: (fields[4] as List?)?.cast<String>(),
      isPodcastsChecked: fields[9] as bool?,
      isMoviesChecked: fields[10] as bool?,
      isTvChecked: fields[11] as bool?,
      isPodcastFilterChecked: fields[14] as bool?,
      isTVFilterChecked: fields[12] as bool?,
      isMovieFilterChecked: fields[13] as bool?,
      podcastGenres: (fields[3] as List?)?.cast<String>(),
      tvGenreIds: (fields[5] as List?)?.cast<String>(),
      watchProviderIds: (fields[6] as List?)?.cast<String>(),
      favorites: fields[15] as dynamic,
      accessToken: fields[7] as String?,
      accessTokenExpiresIn: fields[16] as int?,
      accessTokenCreatedAt: fields[17] as DateTime?,
      refreshToken: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.workoutLength)
      ..writeByte(3)
      ..write(obj.podcastGenres)
      ..writeByte(4)
      ..write(obj.movieGenreIds)
      ..writeByte(5)
      ..write(obj.tvGenreIds)
      ..writeByte(6)
      ..write(obj.watchProviderIds)
      ..writeByte(7)
      ..write(obj.accessToken)
      ..writeByte(8)
      ..write(obj.refreshToken)
      ..writeByte(9)
      ..write(obj.isPodcastsChecked)
      ..writeByte(10)
      ..write(obj.isMoviesChecked)
      ..writeByte(11)
      ..write(obj.isTvChecked)
      ..writeByte(12)
      ..write(obj.isTVFilterChecked)
      ..writeByte(13)
      ..write(obj.isMovieFilterChecked)
      ..writeByte(14)
      ..write(obj.isPodcastFilterChecked)
      ..writeByte(15)
      ..write(obj.favorites)
      ..writeByte(16)
      ..write(obj.accessTokenExpiresIn)
      ..writeByte(17)
      ..write(obj.accessTokenCreatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['_id', 'email']);
  return User(
    id: json['_id'] as String?,
    email: json['email'] as String?,
    workoutLength: json['workout_length'] as int?,
    movieGenreIds: (json['movie_genre_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    isPodcastsChecked: json['is_podcasts_checked'] as bool?,
    isMoviesChecked: json['is_movies_checked'] as bool?,
    isTvChecked: json['is_tv_checked'] as bool?,
    isPodcastFilterChecked: json['isPodcastFilterChecked'] as bool? ?? true,
    isTVFilterChecked: json['isTVFilterChecked'] as bool? ?? true,
    isMovieFilterChecked: json['isMovieFilterChecked'] as bool? ?? true,
    podcastGenres: (json['podcast_genres'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    tvGenreIds: (json['tv_genre_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    watchProviderIds: (json['watch_provider_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    favorites: json['favorites'],
    accessToken: json['access_token'] as String?,
    accessTokenExpiresIn: json['access_token_expires_in'] as int?,
    accessTokenCreatedAt: json['access_token_created_at'] == null
        ? null
        : DateTime.parse(json['access_token_created_at'] as String),
    refreshToken: json['refresh_token'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'workout_length': instance.workoutLength,
      'podcast_genres': instance.podcastGenres,
      'movie_genre_ids': instance.movieGenreIds,
      'tv_genre_ids': instance.tvGenreIds,
      'watch_provider_ids': instance.watchProviderIds,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'is_podcasts_checked': instance.isPodcastsChecked,
      'is_movies_checked': instance.isMoviesChecked,
      'is_tv_checked': instance.isTvChecked,
      'isTVFilterChecked': instance.isTVFilterChecked,
      'isMovieFilterChecked': instance.isMovieFilterChecked,
      'isPodcastFilterChecked': instance.isPodcastFilterChecked,
      'favorites': instance.favorites,
      'access_token_expires_in': instance.accessTokenExpiresIn,
      'access_token_created_at':
          instance.accessTokenCreatedAt?.toIso8601String(),
    };
