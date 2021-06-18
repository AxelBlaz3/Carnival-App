import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'podcast.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class PodcastResponse extends HiveObject {
  @HiveField(4)
  @JsonKey(name: 'total_runtime')
  final int? totalRuntime;

  @HiveField(5)
  @JsonKey(name: 'avg_runtime')
  final int? averageRuntime;

  @HiveField(6)
  @JsonKey(name: 'five_min')
  List<dynamic>? fiveMinpodcasts = [];

  @HiveField(8)
  @JsonKey(name: 'response_title', defaultValue: '')
  String? responseTitle;

  @HiveField(9)
  String? genre;

  @HiveField(10)
  @JsonKey(name: 'ten_min')
  List<dynamic>? tenMinpodcasts = [];

  @HiveField(11)
  @JsonKey(name: 'fifteen_min')
  List<dynamic>? fifteenMinpodcasts = [];

  @HiveField(12)
  @JsonKey(name: 'twenty_min')
  List<dynamic>? twentyMinpodcasts = [];

  PodcastResponse(
      {
      this.fiveMinpodcasts,
      this.tenMinpodcasts,
      this.fifteenMinpodcasts,
      this.twentyMinpodcasts,
      this.genre,
      this.averageRuntime,
      this.totalRuntime,
      this.responseTitle});

  factory PodcastResponse.fromJson(Map<String, dynamic> json) =>
      _$PodcastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastResponseToJson(this);
}

@HiveType(typeId: 8)
@JsonSerializable()
class Podcast {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  @JsonKey(name: 'total_episodes')
  final int? totalEpisodes;

  @HiveField(2)
  @JsonKey(name: 'images')
  final List<dynamic>? images;

  @HiveField(3)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(4)
  @JsonKey(name: 'description')
  final String? description;

  @HiveField(5)
  @JsonKey(name: 'total_runtime')
  final int? totalRuntime;

  @HiveField(6)
  @JsonKey(name: 'external_urls')
  final dynamic externalUrl;

  @HiveField(7)
  @JsonKey()
  bool? favorite = false;

  @HiveField(8)
  @JsonKey(name: 'avg_runtime')
  final int? averageRuntime;

  get getIsFavorite => this.favorite ?? false;

  Podcast copyWith(
      {String? id,
      String? description,
      dynamic externalUrl,
      List<dynamic>? images,
      String? name,
      bool? favorite,
      int? totalEpisodes,
      int? totalRuntime,
      int? averageRuntime}) {
    return Podcast(
        description: description ?? this.description,
        id: id ?? this.id,
        externalUrl: externalUrl ?? this.externalUrl,
        name: name ?? this.name,
        images: images ?? this.images,
        favorite: favorite ?? this.favorite,
        totalEpisodes: totalEpisodes ?? this.totalEpisodes,
        totalRuntime: totalRuntime ?? this.totalRuntime,
        averageRuntime: averageRuntime ?? this.averageRuntime);
  }

  Podcast(
      {this.id,
      this.description,
      this.externalUrl,
      this.images,
      this.name,
      this.favorite,
      this.totalEpisodes,
      this.totalRuntime,
      this.averageRuntime});

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastToJson(this);
}

@HiveType(typeId: 9)
@JsonSerializable()
class PodcastImage {
  @HiveField(0)
  final int? height;
  @HiveField(1)
  final int? width;
  @HiveField(2)
  final String? url;

  PodcastImage({this.height, this.width, this.url});

  factory PodcastImage.fromJson(Map<String, dynamic> json) =>
      _$PodcastImageFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastImageToJson(this);
}
