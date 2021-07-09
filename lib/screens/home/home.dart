
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curate_app/colors.dart';
import 'package:curate_app/enums.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:curate_app/screens/detail/detail.dart';
import 'package:curate_app/screens/detail/full_list.dart';
import 'package:curate_app/screens/settings/filter_list.dart';
import 'package:curate_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../helpers.dart';
import '../../models/notifiers/user_model.dart';

class HomePage extends StatefulWidget {
  bool hardRefresh = false;

  HomePage({bool hardRefresh = false}) {
    this.hardRefresh = hardRefresh;
  }

  @override
  _HomePageState createState() =>
      _HomePageState(shouldHardRefresh: hardRefresh);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({shouldHardRefresh}) {
    this.shouldHardRefresh = shouldHardRefresh;
  }

  bool shouldHardRefresh = false;

  // Handles for passing to detail screen.
  String? watchLink;
  String? region;
  String? providerName;
  String? providerImage;

  final placeholderWidget = Container(
      height: 132,
      width: 132,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: whisper));

  var _listLength = 0;
  late Box<TVResponse> tvResponseBoxStore;
  late Box<PodcastResponse> podcastResponseBoxStore;
  late Box<MovieResponse> movieResponseBoxStore;

  final _mainScrollController = ScrollController();

  Future? fetchInitialCategoriesFuture;

  Row _buildHeader() {
    return Row(
      children: [
        SizedBox(
          width: 16,
        ),
        Text(
          "Your\nrecommendations",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.w600, color: mulledWine, fontSize: 24),
        ),
        Spacer(),
        IconButton(
            icon: SvgPicture.asset('assets/icon/configure.svg'),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return FilterListPage();
              }));
              setState(() {});
            }),
        IconButton(
            icon: SvgPicture.asset('assets/icon/settings.svg'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SettingsPage();
              }));
            }),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  Container _buildLoadingWidget(UserModel userModel, {bool errorFlag = false}) {
    return Container(
        padding: EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              errorFlag
                  ? "Oops, seems like a network issue 😧"
                  : "Doing the magic, hold tight 🤓",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, color: mulledWine),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
                height: 20,
                width: 20,
                child: !errorFlag
                    ? CircularProgressIndicator(
                        color: royalBlue,
                      )
                    : SizedBox()),
            errorFlag
                ? ElevatedButton(
                    onPressed: () => refresh(),
                    child: Text('Retry'),
                    style: ElevatedButtonTheme.of(context).style!.copyWith(
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 0))))
                : SizedBox()
          ],
        ));
  }

  SizedBox _buildProgressIndicator() {
    return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: royalBlue,
        ));
  }

  @override
  void initState() {
    super.initState();

    //launchApp();

    tvResponseBoxStore = Hive.box<TVResponse>(tvResponseBox);
    podcastResponseBoxStore = Hive.box<PodcastResponse>(podcastResponseBox);
    movieResponseBoxStore = Hive.box<MovieResponse>(movieResponseBox);

    final userModel = Provider.of<UserModel>(context, listen: false);
    fetchInitialCategoriesFuture = userModel.fetchInitialCategories(context,
        shouldHardRefresh: shouldHardRefresh,
        region: WidgetsBinding.instance!.window.locale.countryCode ?? 'US');

    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        if (userModel.getPaginationFetchingStatus ==
            PaginationFetchingStatus.idle) {
          fetchCategories(userModel);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    final _user = userModel.sampleUser;

    return Scaffold(
        body: SafeArea(
            child: FutureBuilder<void>(
      future: fetchInitialCategoriesFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingWidget(userModel);
          default:
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                userModel.fetchInitialCategories(context,
                    region:
                        WidgetsBinding.instance!.window.locale.countryCode ??
                            'US');
                return _buildLoadingWidget(userModel);
              }

              var nothingFlag = true;
              for (final content in userModel.curatedContent) {
                if (content is TVResponse) {
                  if (content.tvShows != null && content.tvShows!.isNotEmpty) {
                    nothingFlag = false;

                    break;
                  }
                }
                if (content is MovieResponse) {
                  if (content.movies != null && content.movies!.isNotEmpty) {
                    nothingFlag = false;
                    break;
                  }
                }
                if (content is PodcastResponse) {
                  if ((content.fiveMinpodcasts != null &&
                content.fiveMinpodcasts!.isNotEmpty) ||
            (content.tenMinpodcasts != null &&
                content.tenMinpodcasts!.isNotEmpty) ||
            (content.fifteenMinpodcasts != null &&
                content.fifteenMinpodcasts!.isNotEmpty) ||
            (content.twentyMinpodcasts != null &&
                content.twentyMinpodcasts!.isNotEmpty)) {
                  nothingFlag = false;
                  break;
                }
                }
              }

              if (nothingFlag) {
                Future.microtask(() => triggerAwkwardSheet(context));
                return SizedBox();
              }


              if (userModel.curatedContent.isEmpty) {
                Future.microtask(() => triggerAwkwardSheet(context));
                return SizedBox();
              }
              // if (userModel.sampleUser!.getIsTvChecked) {
              //   for (final key in tvResponseBoxStore.keys) {
              //     final currentItem =
              //         tvResponseBoxStore.get(key, defaultValue: null);
              //     if (currentItem == null) continue;
              //     found = found ||
              //         (currentItem.tvShows != null &&
              //             currentItem.tvShows!.isNotEmpty);
              //     if (found) {
              //       break;
              //     }
              //   }
              // }
              // if (!found && userModel.sampleUser!.getIsMoviesChecked) {
              //   for (final key in movieResponseBoxStore.keys) {
              //     final currentItem =
              //         movieResponseBoxStore.get(key, defaultValue: null);
              //     if (currentItem == null) continue;
              //     found = found ||
              //         (currentItem.movies != null &&
              //             currentItem.movies!.isNotEmpty);
              //     if (found) {
              //       break;
              //     }
              //   }
              // }
              // if (!found && userModel.sampleUser!.getIsPodcastsChecked) {
              //   for (final key in podcastResponseBoxStore.keys) {
              //     final currentItem =
              //         podcastResponseBoxStore.get(key, defaultValue: null);
              //     if (currentItem == null) continue;
              //     final isAnyListFilled =
              //         (currentItem.fiveMinpodcasts != null &&
              //                 currentItem.fiveMinpodcasts!.isNotEmpty) ||
              //             (currentItem.tenMinpodcasts != null &&
              //                 currentItem.tenMinpodcasts!.isNotEmpty) ||
              //             (currentItem.fifteenMinpodcasts != null &&
              //                 currentItem.fifteenMinpodcasts!.isNotEmpty) ||
              //             (currentItem.twentyMinpodcasts != null &&
              //                 currentItem.twentyMinpodcasts!.isNotEmpty);
              //     found = found || isAnyListFilled;
              //     if (found) {
              //       break;
              //     }
              //   }
              // }

              return Consumer<UserModel>(builder: (context, userModel, child) {
                int maxPossibleLength = 0;

                if (_user!.getIsTvChecked) maxPossibleLength += _user.getTvGenreIds.length;
                if (_user.getIsMoviesChecked)
                maxPossibleLength += _user.getMovieGenreIds.length;
                if (_user.getIsPodcastsChecked)
                maxPossibleLength += _user.getPodcastGenres.length;

                final isFavAvailable = _user.getFavorites != null &&
                    _user.getFavorites!.isNotEmpty &&
                    (_user.getFavorites['movies'].isNotEmpty ||
                        _user.getFavorites['shows'].isNotEmpty ||
                        _user.getFavorites['podcasts'].isNotEmpty);
                if (isFavAvailable) {
                  maxPossibleLength++;
                }
                if (_user.getIsMoviesChecked) {
                  maxPossibleLength++;
                }
                if (_user.getIsTvChecked) {
                  maxPossibleLength++;
                }
                // if (userModel.curatedContent.length +
                //               userModel.contentToBeFiltered <
                //           maxPossibleLength) {
                //         fetchCategories(userModel);
                //       }
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: _mainScrollController,
                    itemCount: isFavAvailable
                        ? userModel.curatedContent.length + 5
                        : userModel.curatedContent.length + 4,
                    itemBuilder: (context, index) {
                      final overallLength = isFavAvailable
                          ? userModel.curatedContent.length + 1
                          : userModel.curatedContent.length;
                      final shouldFetch =
                          overallLength + userModel.contentToBeFiltered <
                              maxPossibleLength;
                      if (shouldFetch) {
                        if (userModel.getPaginationFetchingStatus ==
                            PaginationFetchingStatus.idle) {
                          Future.microtask(() => fetchCategories(userModel));
                        }
                      }

                      if (index == 0 || index == 2)
                        return SizedBox(
                          height: 24,
                        );
                      else if (index == 1)
                        return _buildHeader();
                      else {
                        final isFavAvailable = _user.getFavorites != null &&
                            _user.getFavorites!.isNotEmpty &&
                            (_user.getFavorites['movies'].isNotEmpty ||
                                _user.getFavorites['shows'].isNotEmpty ||
                                _user.getFavorites['podcasts'].isNotEmpty);
                        if (index == 3 && isFavAvailable) {
                          return _buildCategory(
                              mapKey: "-1",
                              title: 'Favourites',
                              userModel: userModel);
                        }

                        final content;
                        try {
                          content = userModel.curatedContent
                              .toList()[isFavAvailable ? index - 4 : index - 3];
                        } on RangeError catch (e) {
                          return shouldFetch
                              ? Container(
                                  margin: EdgeInsets.all(24),
                                  child:
                                      Center(child: _buildProgressIndicator()))
                              : SizedBox();
                        }
                        if (content is TVResponse &&
                            _user.getIsTvChecked &&
                            _user.getIsTvFilterChecked && content.tvShows != null && content.tvShows!.isNotEmpty) {
                          return _buildCategory(
                              mapKey: content.isTopCategory!
                                  ? 'top_tv_shows'
                                  : '${content.genre}_tv',
                              userModel: userModel,
                              tvResponse: content,
                              title: content.responseTitle!,
                              category: WorkoutCategory.SHOW,
                              categoryItems: content.tvShows,
                              controllerIndex: index - 3);
                        } else if (content is MovieResponse &&
                            _user.getIsMoviesChecked &&
                            _user.getIsMoviesFilterChecked && content.movies != null && content.movies!.isNotEmpty){
                          return _buildCategory(
                              mapKey: content.isTopCategory!
                                  ? 'top_movies'
                                  : '${content.genre}_movie',
                              userModel: userModel,
                              movieResponse: content,
                              title: content.responseTitle!,
                              category: WorkoutCategory.MOVIE,
                              categoryItems: content.movies,
                              controllerIndex: index - 3);
                        } else if (content is PodcastResponse &&
                            _user.getIsPodcastsChecked &&
                            _user.getIsPodcastsFilterChecked) {
                          final categories = <Widget>[];
                          if (content.fiveMinpodcasts != null &&
                              content.fiveMinpodcasts!.isNotEmpty) {
                            categories.add(_buildCategory(
                                mapKey: content.genre,
                                userModel: userModel,
                                podcastResponse: content,
                                isFiveMinutePodcast: true,
                                title:
                                    '${SPOTIFY_GENRES[content.genre]} podcasts you can do in under 5 workouts',
                                category: WorkoutCategory.PODCAST,
                                categoryItems: content.fiveMinpodcasts,
                                controllerIndex: index - 3));
                          }
                          if (content.tenMinpodcasts != null &&
                              content.tenMinpodcasts!.isNotEmpty) {
                            categories.add(_buildCategory(
                                mapKey: content.genre,
                                userModel: userModel,
                                isTenMinutePodcast: true,
                                podcastResponse: content,
                                title:
                                    '${SPOTIFY_GENRES[content.genre]} podcasts you can do in under 10 workouts',
                                category: WorkoutCategory.PODCAST,
                                categoryItems: content.tenMinpodcasts,
                                controllerIndex: index - 3));
                          }
                          if (content.fifteenMinpodcasts != null &&
                              content.fifteenMinpodcasts!.isNotEmpty) {
                            categories.add(_buildCategory(
                                mapKey: content.genre,
                                userModel: userModel,
                                isFifteenMinutePodcast: true,
                                podcastResponse: content,
                                title:
                                    '${SPOTIFY_GENRES[content.genre]} podcasts you can do in under 15 workouts',
                                category: WorkoutCategory.PODCAST,
                                categoryItems: content.fifteenMinpodcasts,
                                controllerIndex: index - 3));
                          }
                          if (content.twentyMinpodcasts != null &&
                              content.twentyMinpodcasts!.isNotEmpty) {
                            categories.add(_buildCategory(
                                mapKey: content.genre,
                                userModel: userModel,
                                isTwentyMinutePodcast: true,
                                podcastResponse: content,
                                title:
                                    '${SPOTIFY_GENRES[content.genre]} podcasts you can do in under 20 workouts',
                                category: WorkoutCategory.PODCAST,
                                categoryItems: content.twentyMinpodcasts,
                                controllerIndex: index - 3));
                          }
                          if (categories.isEmpty) {
                            categories.add(SizedBox());
                          }
                          return Column(children: categories);
                        } else {
                          return SizedBox();
                        }
                      }
                      // if (tvResponseBoxStore
                      //         .containsKey('top_tv_shows') &&
                      //     _user.getIsTvFilterChecked) {
                      //   final tvResponse =
                      //       tvResponseBoxStore.get('top_tv_shows')!;
                      //   if (tvResponse.tvShows != null &&
                      //       tvResponse.tvShows!.isNotEmpty) {
                      //     categories.add(_buildCategory(
                      //         mapKey: 'top_tv_shows',
                      //         userModel: userModel,
                      //         tvResponse: tvResponse,
                      //         title: tvResponse.responseTitle!,
                      //         category: WorkoutCategory.SHOW,
                      //         categoryItems: tvResponse.tvShows,
                      //         controllerIndex: index - 3));
                      //   }
                      // }
                      // if (movieResponseBoxStore
                      //         .containsKey('top_movies') &&
                      //     _user.getIsMoviesFilterChecked) {
                      //   final movieResponse =
                      //       movieResponseBoxStore.get('top_movies')!;
                      //   if (movieResponse.movies != null &&
                      //       movieResponse.movies!.isNotEmpty) {
                      //     categories.add(_buildCategory(
                      //         mapKey: 'top_movies',
                      //         userModel: userModel,
                      //         movieResponse: movieResponse,
                      //         title: movieResponse.responseTitle!,
                      //         category: WorkoutCategory.MOVIE,
                      //         categoryItems: movieResponse.movies,
                      //         controllerIndex: index - 3));
                      //   }
                      // }

                      // if (_user.getIsTvFilterChecked)
                      //   for (final key in tvResponseBoxStore.keys) {
                      //     if (key == 'top_tv_shows') continue;
                      //     final tvResponse = tvResponseBoxStore.get(key);
                      //     if (tvResponse == null) continue;
                      //     final tvShows = tvResponse.tvShows;
                      //     if (tvShows == null || tvShows.isEmpty)
                      //       continue;
                      //     categories.add(_buildCategory(
                      //         mapKey: key,
                      //         userModel: userModel,
                      //         tvResponse: tvResponse,
                      //         title: tvResponse.responseTitle!,
                      //         category: WorkoutCategory.SHOW,
                      //         categoryItems: tvShows,
                      //         controllerIndex: index - 3));
                      //   }

                      // if (_user.getIsMoviesFilterChecked)
                      //   for (final key in movieResponseBoxStore.keys) {
                      //     if (key == 'top_movies') continue;
                      //     final movieResponse =
                      //         movieResponseBoxStore.get(key);
                      //     if (movieResponse == null) continue;
                      //     final movies = movieResponse.movies;
                      //     if (movies == null || movies.isEmpty) continue;
                      //     categories.add(_buildCategory(
                      //         mapKey: key,
                      //         userModel: userModel,
                      //         movieResponse: movieResponse,
                      //         title: movieResponse.responseTitle!,
                      //         category: WorkoutCategory.MOVIE,
                      //         categoryItems: movies,
                      //         controllerIndex: index - 3));
                      //   }

                      // if (_user.getIsPodcastsFilterChecked)
                      //   for (final key in podcastResponseBoxStore.keys) {
                      //     final podcastResponse =
                      //         podcastResponseBoxStore.get(key);
                      //     if (podcastResponse == null) continue;
                      //     if (podcastResponse.fiveMinpodcasts != null &&
                      //         podcastResponse
                      //             .fiveMinpodcasts!.isNotEmpty) {
                      //       categories.add(_buildCategory(
                      //           mapKey: key,
                      //           userModel: userModel,
                      //           podcastResponse: podcastResponse,
                      //           isFiveMinutePodcast: true,
                      //           title:
                      //               '${SPOTIFY_GENRES[key]} podcasts you can do in 5 workouts',
                      //           category: WorkoutCategory.PODCAST,
                      //           categoryItems:
                      //               podcastResponse.fiveMinpodcasts,
                      //           controllerIndex: index - 3));
                      //     }
                      //     if (podcastResponse.tenMinpodcasts != null &&
                      //         podcastResponse
                      //             .tenMinpodcasts!.isNotEmpty) {
                      //       categories.add(_buildCategory(
                      //           mapKey: key,
                      //           userModel: userModel,
                      //           isTenMinutePodcast: true,
                      //           podcastResponse: podcastResponse,
                      //           title:
                      //               '${SPOTIFY_GENRES[key]} podcasts you can do in 10 workouts',
                      //           category: WorkoutCategory.PODCAST,
                      //           categoryItems:
                      //               podcastResponse.tenMinpodcasts,
                      //           controllerIndex: index - 3));
                      //     }
                      //     if (podcastResponse.fifteenMinpodcasts !=
                      //             null &&
                      //         podcastResponse
                      //             .fifteenMinpodcasts!.isNotEmpty) {
                      //       categories.add(_buildCategory(
                      //           mapKey: key,
                      //           userModel: userModel,
                      //           isFifteenMinutePodcast: true,
                      //           podcastResponse: podcastResponse,
                      //           title:
                      //               '${SPOTIFY_GENRES[key]} podcasts you can do in 15 workouts',
                      //           category: WorkoutCategory.PODCAST,
                      //           categoryItems:
                      //               podcastResponse.fifteenMinpodcasts,
                      //           controllerIndex: index - 3));
                      //     }
                      //     if (podcastResponse.twentyMinpodcasts != null &&
                      //         podcastResponse
                      //             .twentyMinpodcasts!.isNotEmpty) {
                      //       categories.add(_buildCategory(
                      //           mapKey: key,
                      //           userModel: userModel,
                      //           isTwentyMinutePodcast: true,
                      //           podcastResponse: podcastResponse,
                      //           title:
                      //               '${SPOTIFY_GENRES[key]} podcasts you can do in 20 workouts',
                      //           category: WorkoutCategory.PODCAST,
                      //           categoryItems:
                      //               podcastResponse.twentyMinpodcasts,
                      //           controllerIndex: index - 3));
                      //     }
                      //   }
                      // else
                      //   return Consumer<UserModel>(
                      //     builder: (context, value, child) {
                      //       updateListLength(tvResponseBoxStore,
                      //           movieResponseBoxStore, podcastResponseBoxStore);
                      //       if (userModel.curatedContent.length +
                      //               userModel.contentToBeFiltered ==
                      //           maxPossibleLength) return SizedBox();
                      //       fetchCategories(userModel);
                      //       return Container(
                      //           margin: EdgeInsets.all(24),
                      //           child:
                      //               Center(child: _buildProgressIndicator()));
                      //     },
                      //   );
                    });
              });
            } else
              return _buildLoadingWidget(userModel);
        }
      },
    )));
  }

  Widget _buildCategory(
      {required String title,
      int? controllerIndex,
      @required String? mapKey,
      TVResponse? tvResponse,
      MovieResponse? movieResponse,
      PodcastResponse? podcastResponse,
      bool? isFiveMinutePodcast = false,
      bool? isTenMinutePodcast = false,
      bool? isFifteenMinutePodcast = false,
      bool? isTwentyMinutePodcast = false,
      @required UserModel? userModel,
      List<dynamic>? categoryItems,
      WorkoutCategory? category}) {
    final _isFavorites = title == 'Favourites';
    List<dynamic> favoriteItems = [];
    if (_isFavorites) {
      final user = userModel!.user;
      final favouriteMovies = user!.getFavorites!['movies'];
      for (final favouriteMovie in favouriteMovies) {
        favoriteItems
            .add(Movie.fromJson(Map<String, dynamic>.from(favouriteMovie)));
      }
      final favouriteShows = user.getFavorites!['shows'];
      for (final favouriteShow in favouriteShows) {
        favoriteItems
            .add(TV.fromJson(Map<String, dynamic>.from(favouriteShow)));
      }
      final favouritePodcasts = user.getFavorites!['podcasts'];
      for (final favouritePodcast in favouritePodcasts) {
        favoriteItems
            .add(Podcast.fromJson(Map<String, dynamic>.from(favouritePodcast)));
      }

      if (favoriteItems.isEmpty) return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            )),
        SizedBox(
            height: 150,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                //physics: _physics,
                //controller: _scrollControllers[controllerIndex],
                itemCount: !_isFavorites
                    ? (categoryItems == null
                        ? 10
                        : categoryItems.length > 10
                            ? 10
                            : categoryItems.length)
                    : favoriteItems.length > 10
                        ? 10
                        : favoriteItems.length,
                itemBuilder: (context, index) {
                  if (!_isFavorites) {
                    if (categoryItems is List<TV>) {
                      if (categoryItems[index].watchProviders!.isEmpty)
                        return SizedBox();
                      return Container(
                          width: MediaQuery.of(context).size.width / 1.25,
                          child: _buildTVCategoryItem(categoryItems[index],
                              index, mapKey!, userModel!));
                    } else if (categoryItems is List<Movie>) {
                      if (categoryItems[index].watchProviders!.isEmpty)
                        return SizedBox();
                      return Container(
                          width: MediaQuery.of(context).size.width / 1.25,
                          child: _buildMovieCategoryItem(categoryItems[index],
                              index, mapKey!, userModel!));
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: _buildPodcastCategoryItem(
                          Podcast.fromJson(
                              Map<String, dynamic>.from(categoryItems![index])),
                          index,
                          mapKey!,
                          userModel!,
                          isFifteenMinPodcast: isFifteenMinutePodcast!,
                          isTenMinPodcast: isTenMinutePodcast!,
                          isFiveMinPodcast: isFiveMinutePodcast!,
                          isTwentyMinPodcast: isTwentyMinutePodcast!,
                        ),
                      );
                    }
                  } else {
                    return Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: favoriteItems[index] is TV
                            ? _buildTVCategoryItem(favoriteItems[index], index,
                                mapKey!, userModel!)
                            : favoriteItems[index] is Movie
                                ? _buildMovieCategoryItem(favoriteItems[index],
                                    index, mapKey!, userModel!)
                                : _buildPodcastCategoryItem(
                                    favoriteItems[index],
                                    index,
                                    mapKey!,
                                    userModel!));
                  }
                })),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return _isFavorites
                  ? FullListPage(
                      listTitle: title,
                      mapKey: "-1",
                      isFavourites: true,
                    )
                  : category == WorkoutCategory.SHOW
                      ? FullListPage(
                          listTitle: title,
                          mapKey: mapKey,
                          tvResponse: tvResponse)
                      : category == WorkoutCategory.MOVIE
                          ? FullListPage(
                              listTitle: title,
                              mapKey: mapKey,
                              movieResponse: movieResponse)
                          : FullListPage(
                              listTitle: title,
                              mapKey: mapKey,
                              isFiveMinPodcasts: isFiveMinutePodcast!,
                              isTenMinPodcasts: isTenMinutePodcast!,
                              isFifteenMinPodcasts: isFifteenMinutePodcast!,
                              isTwentyMinPodcasts: isTwentyMinutePodcast!,
                              podcastResponse: podcastResponse);
            }));
          },
          child: Text("View full list"),
          style: Theme.of(context).textButtonTheme.style!.copyWith(
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 8, horizontal: 16))),
        )
      ],
    );
  }

  Widget _buildPodcastCategoryItem(
      Podcast podcast, int index, String mapKey, UserModel userModel,
      {bool isFiveMinPodcast = false,
      bool isTenMinPodcast = false,
      bool isFifteenMinPodcast = false,
      bool isTwentyMinPodcast = false}) {
    return GestureDetector(
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
                  imageUrl: podcast.images![1]['url']!,
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
                        onTap: () =>
                            onPodcastFavouriteTap(podcast, context, userModel),
                        child: Icon(
                          userModel.user!.getFavorites['podcasts'].firstWhere(
                                      (e) => e['id'] == podcast.id,
                                      orElse: () => null) !=
                                  null
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: violetRed,
                        ),
                      ),
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
    final providerImageUrl =
        getProviderImageUrl(WorkoutCategory.MOVIE, movie: movie);
    final providerMetaData =
        parseTMDBProviderData(userModel, WorkoutCategory.MOVIE, movie: movie);

    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryDetailPage(WorkoutCategory.MOVIE,
                movie: movie,
                mapKey: mapKey,
                index: index,
                region: providerImageUrl[2],
                providerMetaData: providerMetaData,
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
                            userModel.user!.getFavorites['movies'].firstWhere(
                                        (e) => e['id'] == movie.id,
                                        orElse: () => null) !=
                                    null
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
                                  '${movie.tmdbImageBaseUrl}${providerMetaData.logoPath!}',
                              height: 24,
                              width: 24,
                              placeholder: (context, url) => SizedBox(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                              errorWidget: (context, url, error) => SizedBox())
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
    final providerImageUrl = getProviderImageUrl(WorkoutCategory.SHOW, tv: tv);
    final providerMetaData =
        parseTMDBProviderData(userModel, WorkoutCategory.SHOW, tv: tv);

    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryDetailPage(WorkoutCategory.SHOW,
                tv: tv,
                mapKey: mapKey,
                index: index,
                providerMetaData: providerMetaData,
                region: providerImageUrl[2],
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
                  errorWidget: (context, url, error) => placeholderWidget,
                  placeholder: (context, url) => placeholderWidget,
                  imageUrl: tv.imageUrl!,
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
                          onTap: () => onTVFavouriteTap(tv, context, userModel),
                          child: Icon(
                            userModel.user!.getFavorites['shows'].firstWhere(
                                        (e) => e['id'] == tv.id,
                                        orElse: () => null) !=
                                    null
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
                              width: 24,
                              placeholder: (context, url) => SizedBox(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                              errorWidget: (context, url, error) => SizedBox())
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }

  Future<void> fetchCategories(UserModel userModel) async {
    final currentRegion =
        WidgetsBinding.instance!.window.locale.countryCode ?? 'US';
    final _user = userModel.sampleUser!;
    int tvFetchIndex = -1;
    int movieFetchIndex = -1;
    int podcastFetchIndex = 0;
    userModel.curatedContent.forEach((element) {
      if (element is TVResponse)
        tvFetchIndex++;
      else if (element is PodcastResponse)
        podcastFetchIndex++;
      else
        movieFetchIndex++;
    });

    if (_user.getIsTvChecked &&
        tvFetchIndex != -1 &&
        (tvFetchIndex + userModel.showsTotalContentFilterCount <
            _user.getTvGenreIds.length)) {
      if (userModel.getPaginationFetchingStatus ==
          PaginationFetchingStatus.idle) {
        final index = tvFetchIndex + userModel.showsTotalContentFilterCount;
        //if (index >= _user.getTvGenreIds.length) return;

        userModel.paginationStatus = PaginationFetchingStatus.loading;
        
        await userModel.fetchTVShows(
            shouldNotify: true,
            page: 1,
            region: currentRegion,
            isGenreSpecific: tvFetchIndex != -1,
            genreId: int.parse(_user.getTvGenreIds[index]));
      }
    } else if (_user.getIsMoviesChecked &&
        movieFetchIndex != -1 &&
        movieFetchIndex + userModel.moviesTotalContentFilterCount <
            _user.movieGenreIds!.length) {
      if (userModel.getPaginationFetchingStatus ==
          PaginationFetchingStatus.idle) {
        final index = movieFetchIndex + userModel.moviesTotalContentFilterCount;
        //if (index >= _user.getMovieGenreIds.length) return;
        userModel.paginationStatus = PaginationFetchingStatus.loading;
        
        await userModel.fetchMovies(
            shouldNotify: true,
            page: 1,
            region: currentRegion,
            isGenreSpecific: movieFetchIndex != -1,
            genreId: int.parse(_user.getMovieGenreIds[index]));
      }
    } else if (_user.getIsPodcastsChecked &&
        podcastFetchIndex + userModel.podcastsTotalContentFilterCount <
            _user.podcastGenres!.length) {
      if (userModel.getPaginationFetchingStatus ==
          PaginationFetchingStatus.idle) {
        final index =
            podcastFetchIndex + userModel.podcastsTotalContentFilterCount;
        //if (index >= _user.getPodcastGenres.length) return;
        userModel.paginationStatus = PaginationFetchingStatus.loading;

        await userModel.fetchPodcasts(
            shouldNotify: true,
            region: currentRegion,
            genre: _user.getPodcastGenres[index]);
      }
    }
  }

  void updateListLength(Box<TVResponse> tvBoxStore,
      Box<MovieResponse> movieBoxStore, Box<PodcastResponse> podcastBoxStore) {
    _listLength =
        tvBoxStore.length + movieBoxStore.length + podcastBoxStore.length;
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

  void refresh() {
    setState(() {});
  }
}
