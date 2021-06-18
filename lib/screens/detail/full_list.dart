import 'package:cached_network_image/cached_network_image.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../helpers.dart';
import 'detail.dart';

class FullListPage extends StatefulWidget {
  TVResponse? tvResponse;
  MovieResponse? movieResponse;
  PodcastResponse? podcastResponse;
  String? listTitle;
  bool? isFavourites = false;
  String? mapKey;
  bool isFiveMinPodcasts = false;
  bool isTenMinPodcasts = false;
  bool isFifteenMinPodcasts = false;
  bool isTwentyMinPodcasts = false;

  FullListPage({
    String? listTitle,
    TVResponse? tvResponse,
    MovieResponse? movieResponse,
    PodcastResponse? podcastResponse,
    List<dynamic>? favoriteItems,
    @required String? mapKey,
    bool? isFavourites = false,
    bool isFiveMinPodcasts = false,
    bool isTenMinPodcasts = false,
    bool isFifteenMinPodcasts = false,
    bool isTwentyMinPodcasts = false,
  }) {
    this.tvResponse = tvResponse;
    this.movieResponse = movieResponse;
    this.podcastResponse = podcastResponse;
    this.mapKey = mapKey;
    this.listTitle = listTitle;
    this.isFavourites = isFavourites;
    this.isFiveMinPodcasts = isFiveMinPodcasts;
    this.isTenMinPodcasts = isTenMinPodcasts;
    this.isFifteenMinPodcasts = isFifteenMinPodcasts;
    this.isTwentyMinPodcasts = isTwentyMinPodcasts;
  }

  @override
  _FullListPageState createState() => _FullListPageState(
      tvResponse: tvResponse,
      movieResponse: movieResponse,
      podcastResponse: podcastResponse,
      listTitle: listTitle,
      mapKey: mapKey,
      isFavourites: isFavourites,
      isFifteenMinPodcasts: isFifteenMinPodcasts,
      isTenMinPodcasts: isTenMinPodcasts,
      isFiveMinPodcasts: isFiveMinPodcasts,
      isTwentyMinPodcasts: isTwentyMinPodcasts);
}

class _FullListPageState extends State<FullListPage> {
  TVResponse? tvResponse;
  MovieResponse? movieResponse;
  PodcastResponse? podcastResponse;
  String? listTitle;
  bool? isFavourites = false;
  int tvIndex = -1;
  int movieIndex = -1;
  int podcastIndex = -1;
  List<dynamic>? favoriteItems;
  bool ignoreDivider = false;
  bool isFiveMinPodcasts = false;
  bool isTenMinPodcasts = false;
  bool isFifteenMinPodcasts = false;
  bool isTwentyMinPodcasts = false;

  String? mapKey;

  String? watchLink;
  String? region;
  String? providerName;
  String? providerImage;

  final placeholderWidget = Container(
      height: 132,
      width: 132,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: whisper));

  final _controller = ScrollController();

  _FullListPageState({
    TVResponse? tvResponse,
    MovieResponse? movieResponse,
    PodcastResponse? podcastResponse,
    String? listTitle,
    @required String? mapKey,
    bool? isFavourites,
    bool isFiveMinPodcasts = false,
    bool isTenMinPodcasts = false,
    bool isFifteenMinPodcasts = false,
    bool isTwentyMinPodcasts = false,
  }) {
    this.tvResponse = tvResponse;
    this.movieResponse = movieResponse;
    this.podcastResponse = podcastResponse;
    this.listTitle = listTitle;
    this.isFavourites = isFavourites;
    this.mapKey = mapKey;
    this.isFiveMinPodcasts = isFiveMinPodcasts;
    this.isTenMinPodcasts = isTenMinPodcasts;
    this.isFifteenMinPodcasts = isFifteenMinPodcasts;
    this.isTwentyMinPodcasts = isTwentyMinPodcasts;
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // Pagination.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List podcasts = [];
    podcastResponse != null && !isFavourites!
        ? isFiveMinPodcasts
            ? podcasts = podcastResponse!.fiveMinpodcasts!
            : isTenMinPodcasts
                ? podcasts = podcastResponse!.tenMinpodcasts!
                : isFifteenMinPodcasts
                    ? podcasts = podcastResponse!.fifteenMinpodcasts!
                    : podcasts = podcastResponse!.twentyMinpodcasts!
        : podcasts = [];

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black,
          ),
          title: Text(listTitle!),
        ),
        body: Consumer<UserModel>(builder: (context, userModel, child) {
          favoriteItems = [];
          for (final tvShow in userModel.user!.getFavorites['shows']) {
            favoriteItems!.add(TV.fromJson(Map<String, dynamic>.from(tvShow)));
          }
          for (final movie in userModel.user!.getFavorites['movies']) {
            favoriteItems!
                .add(Movie.fromJson(Map<String, dynamic>.from(movie)));
          }
          for (final podcast in userModel.user!.getFavorites['podcasts']) {
            favoriteItems!
                .add(Podcast.fromJson(Map<String, dynamic>.from(podcast)));
          }

          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 24),
              physics: BouncingScrollPhysics(),
              controller: _controller,
              itemCount: !isFavourites!
                  ? (tvResponse != null
                      ? tvResponse!.tvShows!.length * 2
                      : movieResponse != null
                          ? movieResponse!.movies!.length * 2
                          : podcasts.length * 2)
                  : favoriteItems!.length * 2,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  if (!ignoreDivider)
                    return Divider();
                  else {
                    ignoreDivider = false;
                    return SizedBox();
                  }
                }

                return !isFavourites!
                    ? (tvResponse != null
                        ? _buildTVCategoryItem(tvResponse!.tvShows![index ~/ 2],
                            index ~/ 2, mapKey!, userModel)
                        : movieResponse != null
                            ? _buildMovieCategoryItem(
                                movieResponse!.movies![index ~/ 2],
                                index ~/ 2,
                                mapKey!,
                                userModel)
                            : _buildPodcastCategoryItem(
                                Podcast.fromJson(Map<String, dynamic>.from(
                                    podcasts[index ~/ 2])),
                                index ~/ 2,
                                mapKey!,
                                userModel,
                                isFifteenMinPodcast: isFifteenMinPodcasts,
                                isTenMinPodcast: isTenMinPodcasts,
                                isFiveMinPodcast: isFiveMinPodcasts,
                                isTwentyMinPodcast: isTwentyMinPodcasts,
                              ))
                    : favoriteItems![index ~/ 2] is TV
                        ? _buildTVCategoryItem(favoriteItems![index ~/ 2],
                            index ~/ 2, mapKey!, userModel)
                        : favoriteItems![index ~/ 2] is Movie
                            ? _buildMovieCategoryItem(
                                favoriteItems![index ~/ 2],
                                index ~/ 2,
                                mapKey!,
                                userModel)
                            : _buildPodcastCategoryItem(
                                favoriteItems![index ~/ 2],
                                index ~/ 2,
                                mapKey!,
                                userModel,
                                isFifteenMinPodcast: isFifteenMinPodcasts,
                                isTenMinPodcast: isTenMinPodcasts,
                                isFiveMinPodcast: isFiveMinPodcasts,
                                isTwentyMinPodcast: isTwentyMinPodcasts,
                              );
              });
        }));
  }

  Widget _buildPodcastCategoryItem(
      Podcast podcast, int index, String mapKey, UserModel userModel,
      {bool isFiveMinPodcast = false,
      bool isTenMinPodcast = false,
      bool isFifteenMinPodcast = false,
      bool isTwentyMinPodcast = false}) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryDetailPage(
              WorkoutCategory.PODCAST,
              mapKey: mapKey,
              index: index,
              podcast: podcast,
              isFifteenMinPodcasts: isFifteenMinPodcast,
              isTenMinPodcasts: isTenMinPodcast,
              isFiveMinPodcasts: isFiveMinPodcast,
              isTwentyMinPodcasts: isTwentyMinPodcast,
              providerName: 'Spotify',
              watchLink: podcast.externalUrl!['spotify'],
              region: 'different regions.',
            );
          }));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CachedNetworkImage(
                  placeholder: (context, url) => placeholderWidget,
                  errorWidget: (context, url, error) => placeholderWidget,
                  imageUrl: podcast.images![1]['url'],
                  imageBuilder: (context, imageProvider) => Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '${podcast.totalEpisodes} episodes',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: mulledWine),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'About ${podcast.averageRuntime} min',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: mulledWine),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => onPodcastFavouriteTap(
                              podcast, context, userModel),
                          child: Icon(
                            podcast.getIsFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: violetRed,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: SvgPicture.asset('assets/icon/spotify.svg'),
                      )
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }

  Widget _buildMovieCategoryItem(
      Movie movie, int index, String mapKey, UserModel userModel) {
    if (movie.watchProviders!.isEmpty) {
      ignoreDivider = true;
      return SizedBox();
    }
    final providerImageUrl =
        getProviderImageUrl(WorkoutCategory.MOVIE, movie: movie);
    final providerMetaData =
        parseTMDBProviderData(userModel, WorkoutCategory.MOVIE, movie: movie);

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryDetailPage(WorkoutCategory.MOVIE,
                movie: movie,
                region: providerImageUrl[2],
                mapKey: mapKey,
                providerMetaData: providerMetaData,
                index: index,
                providerImageUrl: providerImageUrl[1],
                providerName: providerImageUrl[0],
                watchLink: providerImageUrl[3]);
          }));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CachedNetworkImage(
                  placeholder: (context, url) => placeholderWidget,
                  errorWidget: (context, url, error) => placeholderWidget,
                  imageUrl: movie.imageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '${movie.voteAverage} ★',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: mulledWine),
                  ),
                  Text(
                    '${movie.runtime} min',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: mulledWine),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () =>
                              onMovieFavouriteTap(movie, context, userModel),
                          child: Icon(
                            movie.getIsFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: violetRed,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      providerMetaData.logoPath!.isEmpty
                          ? SizedBox()
                          : CachedNetworkImage(
                              imageUrl:
                                  '${movie.tmdbImageBaseUrl}${providerMetaData.logoPath}',
                              placeholder: (context, url) => SizedBox(),
                              height: 24,
                              width: 24,
                              errorWidget: (context, url, error) => SizedBox(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            )
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }

  Widget _buildTVCategoryItem(
      TV tv, int index, String mapKey, UserModel userModel) {
    if (tv.watchProviders!.isEmpty) {
      ignoreDivider = true;
      return SizedBox();
    }
    final providerImageUrl = getProviderImageUrl(WorkoutCategory.SHOW, tv: tv);
    final providerMetaData =
        parseTMDBProviderData(userModel, WorkoutCategory.SHOW, tv: tv);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryDetailPage(WorkoutCategory.SHOW,
                tv: tv,
                region: providerImageUrl[2],
                mapKey: mapKey,
                index: index,
                providerMetaData: providerMetaData,
                providerImageUrl: providerImageUrl[1],
                providerName: providerImageUrl[0],
                watchLink: providerImageUrl[3]);
          }));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CachedNetworkImage(
                  placeholder: (context, url) => placeholderWidget,
                  imageUrl: tv.imageUrl!,
                  errorWidget: (context, url, error) => placeholderWidget,
                  imageBuilder: (context, imageProvider) => Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      )),
              SizedBox(
                width: 16,
              ),
              Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tv.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${tv.numberOfSeasons} seasons',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: mulledWine),
                      ),
                      Text(
                        '${tv.voteAverage} ★',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: mulledWine),
                      ),
                      Text(
                        'About ${tv.episodeRuntime!} min',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: mulledWine),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () =>
                                  onTVFavouriteTap(tv, context, userModel),
                              child: Icon(
                                tv.getIsFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: violetRed,
                              )),
                          SizedBox(
                            width: 8,
                          ),
                          providerMetaData.logoPath!.isEmpty
                              ? SizedBox()
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${tv.tmdbImageBaseUrl}${providerMetaData.logoPath}',
                                  height: 24,
                                  placeholder: (context, url) => SizedBox(),
                                  errorWidget: (context, url, error) =>
                                      SizedBox(),
                                  width: 24,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ))
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ));
  }

  List<String> getProviderImageUrl(WorkoutCategory workoutCategory,
      {TV? tv, Movie? movie, Podcast? podcast}) {
    var currentRegion = WidgetsBinding.instance!.window.locale.countryCode;
    if (currentRegion == null || currentRegion.isEmpty) currentRegion = 'US';
    if (workoutCategory == WorkoutCategory.SHOW) {
      final watchProviders = tv!.watchProviders!;
      if (watchProviders.containsKey(currentRegion)) {
        region = countriesMap[currentRegion.toLowerCase()]!;
        String tmdbWatchLink =
            watchProviders[watchProviders.keys.first]['link'];
        tmdbWatchLink =
            tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
        watchLink = tmdbWatchLink;
        for (final provider in watchProviders.entries) {
          if (provider.key == currentRegion) {
            final providerValue = provider.value;
            final flatRateMonetizationType = providerValue['flatrate'];
            if (flatRateMonetizationType != null) {
              for (final providerData in (flatRateMonetizationType as List)) {
                if (TMDB_MOVIE_WATCH_PROVIDERS
                    .containsKey(providerData['provider_id'].toString())) {
                  providerName = TMDB_MOVIE_WATCH_PROVIDERS[
                      providerData['provider_id'].toString()]!;
                  providerImage =
                      tv.tmdbImageBaseUrl! + providerData['logo_path'];
                  return [providerName!, providerImage!, region!, watchLink!];
                }
              }
            } else {
              final firstMonetizationType =
                  providerValue as Map<dynamic, dynamic>;
              providerName =
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['provider_name'];
              providerImage = tv.tmdbImageBaseUrl! +
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['logo_path'];
              return [providerName!, providerImage!, region!, watchLink!];
            }
          }
        }
        return [
          'multiple streaming services',
          '',
          'different regions',
          watchLink!
        ];
      } else if (watchProviders.containsKey('US')) {
        region = 'United States.';
        String tmdbWatchLink =
            watchProviders[watchProviders.keys.first]['link'];
        tmdbWatchLink =
            tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
        watchLink = tmdbWatchLink;
        for (final provider in watchProviders.entries) {
          if (provider.key == 'US') {
            final providerValue = provider.value;

            final flatRateMonetizationType = providerValue['flatrate'];
            if (flatRateMonetizationType != null) {
              for (final providerData in (flatRateMonetizationType as List)) {
                if (TMDB_MOVIE_WATCH_PROVIDERS
                    .containsKey(providerData['provider_id'].toString())) {
                  providerName = TMDB_MOVIE_WATCH_PROVIDERS[
                      providerData['provider_id'].toString()]!;
                  providerImage =
                      tv.tmdbImageBaseUrl! + providerData['logo_path'];
                  return [providerName!, providerImage!, region!, watchLink!];
                }
              }
            } else {
              final firstMonetizationType =
                  providerValue as Map<dynamic, dynamic>;
              providerName =
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['provider_name'];
              providerImage = tv.tmdbImageBaseUrl! +
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['logo_path'];
              return [providerName!, providerImage!, region!, watchLink!];
            }
          }
        }
        return [
          'multiple streaming services',
          '',
          'different regions',
          watchLink!
        ];
      } else {
        String tmdbWatchLink =
            watchProviders[watchProviders.keys.first]['link'];
        tmdbWatchLink =
            tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
        watchLink = tmdbWatchLink;
        return [
          'multiple streaming services',
          '',
          'different regions',
          watchLink!
        ];
      }
    } else {
      final watchProviders = movie!.watchProviders!;

      String tmdbWatchLink = watchProviders[watchProviders.keys.first]['link'];
      tmdbWatchLink =
          tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
      watchLink = tmdbWatchLink;
      if (watchProviders.containsKey(currentRegion)) {
        region = countriesMap[currentRegion.toLowerCase()]!;
        for (final provider in watchProviders.entries) {
          if (provider.key == currentRegion) {
            final providerValue = provider.value;
            final flatRateMonetizationType = providerValue['flatrate'];
            if (flatRateMonetizationType != null) {
              for (final providerData in (flatRateMonetizationType as List)) {
                if (TMDB_MOVIE_WATCH_PROVIDERS
                    .containsKey(providerData['provider_id'].toString())) {
                  providerName = TMDB_MOVIE_WATCH_PROVIDERS[
                      providerData['provider_id'].toString()]!;
                  providerImage =
                      movie.tmdbImageBaseUrl! + providerData['logo_path'];
                  return [providerName!, providerImage!, region!, watchLink!];
                }
              }
            } else {
              final firstMonetizationType =
                  providerValue as Map<dynamic, dynamic>;
              providerName =
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['provider_name'];
              providerImage = movie.tmdbImageBaseUrl! +
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['logo_path'];
              return [providerName!, providerImage!, region!, watchLink!];
            }
          }
        }
        return [
          'multiple streaming services',
          '',
          'different regions',
          watchLink!
        ];
      } else if (watchProviders.containsKey('US')) {
        region = 'United States.';
        String tmdbWatchLink =
            watchProviders[watchProviders.keys.first]['link'];
        tmdbWatchLink =
            tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
        watchLink = tmdbWatchLink;
        for (final provider in watchProviders.entries) {
          if (provider.key == 'US') {
            final providerValue = provider.value;

            final flatRateMonetizationType = providerValue['flatrate'];
            if (flatRateMonetizationType != null) {
              for (final providerData in (flatRateMonetizationType as List)) {
                if (TMDB_MOVIE_WATCH_PROVIDERS
                    .containsKey(providerData['provider_id'].toString())) {
                  providerName = TMDB_MOVIE_WATCH_PROVIDERS[
                      providerData['provider_id'].toString()]!;
                  providerImage =
                      movie.tmdbImageBaseUrl! + providerData['logo_path'];
                  return [providerName!, providerImage!, region!, watchLink!];
                }
              }
            } else {
              final firstMonetizationType =
                  providerValue as Map<dynamic, dynamic>;
              providerName =
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['provider_name'];
              providerImage = movie.tmdbImageBaseUrl! +
                  firstMonetizationType[firstMonetizationType.keys.first][0]
                      ['logo_path'];
              return [providerName!, providerImage!, region!, watchLink!];
            }
          }
        }
        return [
          'multiple streaming services',
          '',
          'different regions',
          watchLink!
        ];
      } else {
        region = 'different regions.';
        String tmdbWatchLink =
            watchProviders[watchProviders.keys.first]['link'];
        tmdbWatchLink =
            tmdbWatchLink.substring(0, tmdbWatchLink.lastIndexOf('/'));
        watchLink = tmdbWatchLink;
        providerName = 'multiple streaming services';
        return [providerName!, '', region!, watchLink!];
      }
    }
  }

  int calculateIndex(
      {bool isMovie = false, bool isTV = false, bool isPodcast = false}) {
    if (isMovie) movieIndex++;
    if (isTV) tvIndex++;
    if (isPodcast) podcastIndex++;
    print('$isMovie $isTV $isPodcast $movieIndex $tvIndex $podcastIndex');
    return isMovie
        ? movieIndex
        : isTV
            ? tvIndex
            : podcastIndex;
  }
}
