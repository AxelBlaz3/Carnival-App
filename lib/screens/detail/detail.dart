import 'package:cached_network_image/cached_network_image.dart';
import 'package:curate_app/constants.dart';
import 'package:curate_app/enums.dart';
import 'package:curate_app/helpers.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors.dart';

class CategoryDetailPage extends StatefulWidget {
  final WorkoutCategory workoutCategory;
  TV? tv;
  Podcast? podcast;
  Movie? movie;
  String? providerName;
  String? providerImageUrl;
  String? region;
  String? watchLink;
  String? mapKey;
  int? index;
  ProviderMetaData? providerMetaData;
  bool isFiveMinPodcasts = false;
  bool isTenMinPodcasts = false;
  bool isFifteenMinPodcasts = false;
  bool isTwentyMinPodcasts = false;

  CategoryDetailPage(this.workoutCategory,
      {TV? tv,
      Movie? movie,
      Podcast? podcast,
      String? providerName,
      String? providerImageUrl,
      String? region,
      String? watchLink,
      ProviderMetaData? providerMetaData,
      bool isFiveMinPodcasts = false,
      bool isTenMinPodcasts = false,
      bool isFifteenMinPodcasts = false,
      bool isTwentyMinPodcasts = false,
      @required String? mapKey,
      @required int? index}) {
    this.tv = tv;
    this.movie = movie;
    this.podcast = podcast;
    this.providerName = providerName;
    this.providerImageUrl = providerImageUrl;
    this.providerMetaData = providerMetaData;
    this.isFiveMinPodcasts = isFiveMinPodcasts;
    this.isTenMinPodcasts = isTenMinPodcasts;
    this.isFifteenMinPodcasts = isFifteenMinPodcasts;
    this.isTwentyMinPodcasts = isTwentyMinPodcasts;
    this.region = region;
    this.watchLink = watchLink;
    this.mapKey = mapKey;
    this.index = index;
  }

  @override
  _CategoryDetailPageState createState() =>
      _CategoryDetailPageState(workoutCategory,
          tv: tv,
          podcast: podcast,
          movie: movie,
          providerName: providerName,
          providerImageUrl: providerImageUrl,
          region: region,
          providerMetaData: providerMetaData,
          mapKey: mapKey,
          index: index,
          watchLink: watchLink,
          isFifteenMinPodcasts: isFifteenMinPodcasts,
          isTenMinPodcasts: isTenMinPodcasts,
          isFiveMinPodcasts: isFiveMinPodcasts,
          isTwentyMinPodcasts: isTwentyMinPodcasts);
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late final WorkoutCategory workoutCategory;
  TV? tv;
  Movie? movie;
  Podcast? podcast;
  String? region;
  String? watchLink;
  String? providerName;
  String? providerImageUrl;
  String? mapKey;
  int? index;
  ProviderMetaData? providerMetaData;
  bool isFiveMinPodcasts = false;
  bool isTenMinPodcasts = false;
  bool isFifteenMinPodcasts = false;
  bool isTwentyMinPodcasts = false;

  final placeholderWidget = Container(
      height: 132,
      width: 132,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: whisper));

  _CategoryDetailPageState(WorkoutCategory workoutCategory,
      {TV? tv,
      Movie? movie,
      Podcast? podcast,
      String? providerName,
      String? providerImageUrl,
      String? region,
      ProviderMetaData? providerMetaData,
      @required String? mapKey,
      @required int? index,
      bool isFiveMinPodcasts = false,
      bool isTenMinPodcasts = false,
      bool isFifteenMinPodcasts = false,
      bool isTwentyMinPodcasts = false,
      String? watchLink}) {
    this.workoutCategory = workoutCategory;
    this.tv = tv;
    this.movie = movie;
    this.podcast = podcast;
    this.providerName = providerName;
    this.providerImageUrl = providerImageUrl;
    this.providerMetaData = providerMetaData;
    this.region = region;
    this.watchLink = watchLink;
    this.mapKey = mapKey;
    this.index = index;
    this.isFiveMinPodcasts = isFiveMinPodcasts;
    this.isTenMinPodcasts = isTenMinPodcasts;
    this.isFifteenMinPodcasts = isFifteenMinPodcasts;
    this.isTwentyMinPodcasts = isTwentyMinPodcasts;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(workoutCategory == WorkoutCategory.SHOW
            ? tv!.name!
            : workoutCategory == WorkoutCategory.MOVIE
                ? movie!.title!
                : podcast!.name!),
      ),
      body: SafeArea(
          child: Column(children: [
        Expanded(
            child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(24),
          children: [
            workoutCategory == WorkoutCategory.SHOW
                ? _buildTVCategoryItem(tv!, userModel)
                : workoutCategory == WorkoutCategory.MOVIE
                    ? _buildMovieCategoryItem(movie!, userModel)
                    : _buildPodcastCategoryItem(podcast!, userModel),
            SizedBox(
              height: 16,
            ),
            Text(
              workoutCategory == WorkoutCategory.SHOW
                  ? tv!.overview!
                  : workoutCategory == WorkoutCategory.PODCAST
                      ? podcast!.description!
                      : movie!.overview!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: mulledWine, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              workoutCategory == WorkoutCategory.SHOW
                  ? 'You can complete ${(tv!.episodeRuntime! * tv!.numberOfSeasons! * tv!.numberOfEpisodes! / userModel.user!.getWorkoutLength).ceil()} workouts if you complete this show.'
                  : workoutCategory == WorkoutCategory.MOVIE
                      ? 'You can complete ${(movie!.runtime! ~/ userModel.user!.getWorkoutLength).ceil()} workouts if you complete this movie.'
                      : 'You can complete ${(podcast!.averageRuntime! * podcast!.totalEpisodes! / userModel.user!.getWorkoutLength).ceil()} workouts if you complete this podcast.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: caribbeanGreen, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              workoutCategory != WorkoutCategory.PODCAST
                  ? 'How can I watch this?'
                  : 'How can I listen?',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '${workoutCategory == WorkoutCategory.SHOW ? tv!.name! : workoutCategory == WorkoutCategory.MOVIE ? movie!.title! : podcast!.name!} is currently streaming on ${workoutCategory == WorkoutCategory.PODCAST ? "Spotify" : providerMetaData!.name} in $region',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: mulledWine, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 144,
            ),
          ],
        )),
        Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 8),
            child: ElevatedButton(
                onPressed: _launchUrl,
                child: Text(workoutCategory != WorkoutCategory.PODCAST
                    ? 'Watch'
                    : 'Listen'),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 0))))),
        SizedBox(
          height: 16,
        ),
        mapKey != "-1"
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton(
                    onPressed: () {
                      if (userModel.isGuest) {
                        triggerCreateAnAccountSheet(context);
                        return;
                      }
                      userModel.removeCategoryFromBox(
                          index!, mapKey!, workoutCategory,
                          isFifteenMinPodcast: isFifteenMinPodcasts,
                          isTenMinPodcast: isTenMinPodcasts,
                          isFiveMinPodcast: isFiveMinPodcasts,
                          isTwentyMinPodcast: isTwentyMinPodcasts);
                      Navigator.of(context).pop();
                    },
                    child: Text(workoutCategory != WorkoutCategory.PODCAST
                        ? 'I\'ve seen it already'
                        : 'I\'m not interested in this'),
                    style: Theme.of(context)
                        .outlinedButtonTheme
                        .style!
                        .copyWith(
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 0)))))
            : SizedBox(),
        SizedBox(
          height: 24,
        )
      ])),
    );
  }

  Widget _buildPodcastCategoryItem(Podcast podcast, UserModel userModel) {
    return Row(
      children: [
        CachedNetworkImage(
            placeholder: (context, url) => placeholderWidget,
            imageUrl: podcast.images![1]['url'],
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
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
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
                    onTap: () =>
                        onPodcastFavouriteTap(podcast, context, userModel),
                    child: Consumer<UserModel>(
                        builder: (context, value, child) => Icon(
                              userModel.user!.getFavorites['podcasts']
                                          .firstWhere(
                                              (e) => e['id'] == podcast.id,
                                              orElse: () => null) !=
                                      null
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: violetRed,
                            ))),
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
    );
  }

  Widget _buildMovieCategoryItem(Movie movie, UserModel userModel) {
    return Row(
      children: [
        CachedNetworkImage(
            placeholder: (context, url) => placeholderWidget,
            imageUrl: movie.imageUrl!,
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
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
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
                    onTap: () => onMovieFavouriteTap(movie, context, userModel),
                    child: Consumer<UserModel>(
                        builder: (context, value, child) => Icon(
                              userModel.user!.getFavorites['movies'].firstWhere(
                                          (e) => e['id'] == movie.id,
                                          orElse: () => null) !=
                                      null
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: violetRed,
                            ))),
                SizedBox(
                  width: 8,
                ),
                providerMetaData!.logoPath!.isEmpty
                    ? SizedBox()
                    : CachedNetworkImage(
                        imageUrl:
                            '${movie.tmdbImageBaseUrl}${providerMetaData!.logoPath}',
                        height: 24,
                        width: 24,
                        placeholder: (context, url) => SizedBox(),
                        errorWidget: (context, url, error) => SizedBox(),
                        imageBuilder: (context, imageProvider) => Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ))
              ],
            )
          ],
        ))
      ],
    );
  }

  Widget _buildTVCategoryItem(TV tv, UserModel userModel) {
    return Row(
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
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tv.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
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
                    onTap: () => onTVFavouriteTap(tv, context, userModel),
                    child: Consumer<UserModel>(
                        builder: (context, value, child) => Icon(
                              userModel.user!.getFavorites['shows'].firstWhere(
                                          (e) => e['id'] == tv.id,
                                          orElse: () => null) !=
                                      null
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: violetRed,
                            ))),
                SizedBox(
                  width: 8,
                ),
                providerMetaData!.logoPath!.isEmpty
                    ? SizedBox()
                    : CachedNetworkImage(
                        imageUrl:
                            '${tv.tmdbImageBaseUrl}${providerMetaData!.logoPath}',
                        height: 24,
                        width: 24,
                        placeholder: (context, url) => SizedBox(),
                        errorWidget: (context, url, error) => SizedBox(),
                        imageBuilder: (context, imageProvider) => Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ))
              ],
            )
          ],
        ))
      ],
    );
  }

  void _launchUrl() async {
    await canLaunch(workoutCategory == WorkoutCategory.PODCAST
            ? watchLink!
            : watchProviderWebSites[providerMetaData!.providerId!]!)
        ? await launch(workoutCategory == WorkoutCategory.PODCAST
            ? watchLink!
            : watchProviderWebSites[providerMetaData!.providerId!]!)
        : throw 'Could not launch ${workoutCategory == WorkoutCategory.PODCAST ? watchLink! : watchProviderWebSites[providerMetaData!.providerId!]!}';
  }
}
