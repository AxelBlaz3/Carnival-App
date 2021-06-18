import 'dart:convert';
import 'dart:io';

import 'package:curate_app/enums.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:curate_app/models/user.dart';
import 'package:curate_app/screens/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

import '../movie.dart';

class UserModel extends ChangeNotifier {
  Status? _status;
  PaginationFetchingStatus? _paginationFetchingStatus;
  User? sampleUser = User();
  var areAllCategoriesLoaded = false;
  bool isGuest = true;
  bool isNetworkIssue = false;
  String? _errorMessage;
  final Set curatedContent = Set.from([]);
  int contentToBeFiltered = 0;
  int podcastsTotalContentFilterCount = 0;
  int showsTotalContentFilterCount = 0;
  int moviesTotalContentFilterCount = 0;

  Status? get getStatus => _status;

  String? get getErrorMessage => _errorMessage;

  bool get getIsGuest => this.isGuest;

  PaginationFetchingStatus? get getPaginationFetchingStatus =>
      this._paginationFetchingStatus;

  final secureStorage = FlutterSecureStorage();

  set updateStatus(Status status) {
    this._status = status;
    notifyListeners();
  }

  set errorMessage(String errorMessage) => this._errorMessage = errorMessage;

  set paginationStatus(PaginationFetchingStatus status) {
    this._paginationFetchingStatus = status;
  }

  Future<void> saveUser(User? user, {bool shouldNotify = true}) async {
    // await secureStorage.write(key: 'access_token', value: user.getAccessToken);
    // await secureStorage.write(
    //     key: 'refresh_token', value: user.getRefreshToken);
    // saveUserToDB(user);
    final usersBox = Hive.box<User>(userBox);
    if (!isGuest)
      await usersBox.put('user', user!);
    else
      await usersBox.put('guest', user!);

    this.sampleUser = user;
    if (shouldNotify) notifyListeners();
  }

  void updateSampleUser(User sampleUser) {
    this.sampleUser = sampleUser;
    notifyListeners();
  }

  User? get user {
    final usersBox = Hive.box<User>(userBox);
    // if (usersBox.isEmpty || usersBox.get) {
    //   final _finalUser = User();
    //   usersBox.put('user', _finalUser);
    //   this._user = _finalUser;
    // }
    final registeredUser = usersBox.get('user', defaultValue: null);
    final guestUser = usersBox.get('guest', defaultValue: User());
    isGuest = registeredUser == null;
    this.sampleUser = isGuest ? guestUser : registeredUser;
    return this.sampleUser;
  }

  Future<User?> loginUser(String email, String password) async {
    updateStatus = Status.LOADING;
    try {
      final response = await http.post(
        Uri.https(API_BASE_URL, 'carnival/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final userMap = jsonDecode(response.body);
        if (!userMap.containsKey('tv_genre_ids')) userMap['tv_genre_ids'] = [];
        if (!userMap.containsKey('movie_genre_ids'))
          userMap['movie_genre_ids'] = [];
        if (!userMap.containsKey('watch_provider_ids'))
          userMap['watch_provider_ids'] = [];

        userMap['tv_genre_ids'] = (userMap['tv_genre_ids'] as List)
            .map((element) => '$element')
            .toList();
        userMap['movie_genre_ids'] = (userMap['movie_genre_ids'] as List)
            .map((element) => '$element')
            .toList();
        userMap['watch_provider_ids'] = (userMap['watch_provider_ids'] as List)
            .map((element) => '$element')
            .toList();

        final user = User.fromJson(userMap);

        await Hive.box<User>(userBox).clear();
        await Hive.box<TVResponse>(tvResponseBox).clear();
        await Hive.box<MovieResponse>(movieResponseBox).clear();
        await Hive.box<PodcastResponse>(podcastResponseBox).clear();

        isGuest = false;
        curatedContent.clear();
        contentToBeFiltered = 0;
        podcastsTotalContentFilterCount = 0;
        moviesTotalContentFilterCount = 0;
        showsTotalContentFilterCount = 0;
        await saveUser(user..accessTokenCreatedAt = DateTime.now(),
            shouldNotify: false);
        updateStatus = Status.SUCCESS;
        return user;
      } else if (response.statusCode == HttpStatus.forbidden ||
          response.statusCode == HttpStatus.notFound) {
        errorMessage = "That account doesn't exist";
      } else if (response.statusCode == HttpStatus.badRequest) {
        errorMessage = "Invalid login credentials";
      } else {
        errorMessage = "Some error occured";
      }
    } on SocketException {
      errorMessage = "Can't connect to server";
    } on Exception {
      errorMessage = "Some error occured";
    }
    updateStatus = Status.ERROR;
    return user;
  }

  Future<User?> signUp(String email, String password) async {
    updateStatus = Status.LOADING;
    try {
      final response = await http.post(
        Uri.https(API_BASE_URL, 'carnival/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      if (response.statusCode == HttpStatus.created) {
        final user = User.fromJson(jsonDecode(response.body));

        await Hive.box<User>(userBox).clear();
        await Hive.box<TVResponse>(tvResponseBox).clear();
        await Hive.box<MovieResponse>(movieResponseBox).clear();
        await Hive.box<PodcastResponse>(podcastResponseBox).clear();

        isGuest = false;
        curatedContent.clear();
        contentToBeFiltered = 0;
        podcastsTotalContentFilterCount = 0;
        moviesTotalContentFilterCount = 0;
        showsTotalContentFilterCount = 0;
        await saveUser(
          user..accessTokenCreatedAt = DateTime.now(),
          shouldNotify: false,
        );
        updateStatus = Status.SUCCESS;
        return user;
      } else if (response.statusCode == HttpStatus.conflict) {
        errorMessage = "This account already exists";
      }
    } on SocketException {
      errorMessage = "Can't connect to server";
    } on Exception {
      errorMessage = "Some error occured";
    }

    updateStatus = Status.ERROR;
    return sampleUser;
  }

  Future<void> updateUserPreferences(User? updatedUser, BuildContext? context,
      {bool shouldUpdateStatus = true,
      bool isFavorite = false,
      TV? tv,
      Movie? movie,
      Podcast? podcast}) async {
    if (isGuest) return;
    if (shouldUpdateStatus) updateStatus = Status.LOADING;
    try {
      if (context != null) await refreshTokenIfRequired(context);

      final userWithoutTokens = sampleUser!.toJson()
        ..remove('access_token')
        ..remove('refresh_token')
        ..remove('isMovieFilterChecked')
        ..remove('isTVFilterChecked')
        ..remove('isPodcastFilterChecked');
      if (!isFavorite) {
        if (!userWithoutTokens.containsKey('tv_genre_ids'))
          userWithoutTokens['tv_genre_ids'] = [];
        if (!userWithoutTokens.containsKey('movie_genre_ids'))
          userWithoutTokens['movie_genre_ids'] = [];
        if (!userWithoutTokens.containsKey('watch_provider_ids'))
          userWithoutTokens['watch_provider_ids'] = [];

        if (!sampleUser!.getIsMoviesChecked) {
          (userWithoutTokens['movie_genre_ids'] as List).clear();
        }
        if (!sampleUser!.getIsPodcastsChecked) {
          (userWithoutTokens['podcast_genres'] as List).clear();
        }
        if (!sampleUser!.getIsTvChecked) {
          (userWithoutTokens['tv_genre_ids'] as List).clear();
        }

        if ((userWithoutTokens['watch_provider_ids'] as List<String>)
            .isNotEmpty)
          userWithoutTokens['watch_provider_ids'] =
              (userWithoutTokens['watch_provider_ids'] as List<String>)
                  .map(int.parse)
                  .toList();
        if ((userWithoutTokens['movie_genre_ids'] as List<String>).isNotEmpty)
          userWithoutTokens['movie_genre_ids'] =
              (userWithoutTokens['movie_genre_ids'] as List<String>)
                  .map(int.parse)
                  .toList();
        if ((userWithoutTokens['tv_genre_ids'] as List<String>).isNotEmpty)
          userWithoutTokens['tv_genre_ids'] =
              (userWithoutTokens['tv_genre_ids'] as List<String>)
                  .map(int.parse)
                  .toList();
      }

      String body;
      if (!isFavorite) {
        userWithoutTokens['is_favorite'] = isFavorite;
        body = jsonEncode(userWithoutTokens);
      } else {
        final favoriteMap = {};
        favoriteMap['is_favorite'] = isFavorite;
        if (tv != null) favoriteMap['show'] = tv.toJson();
        if (movie != null) favoriteMap['movie'] = movie.toJson();
        if (podcast != null) favoriteMap['podcast'] = podcast.toJson();
        body = jsonEncode(favoriteMap);
      }
      final response = await http.put(
          Uri.https(API_BASE_URL, 'carnival/user/${sampleUser!.getId}'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: 'Bearer ${sampleUser!.accessToken}'
          },
          body: body);

      if (response.statusCode == HttpStatus.ok) {
        if (shouldUpdateStatus) updateStatus = Status.SUCCESS;
        return;
      } else if (response.statusCode == HttpStatus.badRequest) {
        errorMessage = 'Invalid email';
        if (shouldUpdateStatus) updateStatus = Status.ERROR;
      }
    } on SocketException catch (e) {
      print(e);
      errorMessage = 'Can\'t connect to server';
    } on Exception catch (e) {
      print(e);
      errorMessage = 'Some error occured';
    }
    if (shouldUpdateStatus) updateStatus = Status.ERROR;
  }

  Future<bool> sendRandomPasswordToEmail(String email) async {
    if (email.isEmpty) {
      errorMessage = 'Email cannot be empty';
      updateStatus = Status.ERROR;
    }

    updateStatus = Status.LOADING;
    try {
      final response = await http.post(
        Uri.https(API_BASE_URL, 'carnival/email/$email/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF8'
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        updateStatus = Status.SUCCESS;
        return true;
      } else if (response.statusCode == HttpStatus.notFound) {
        errorMessage = 'That email does not exist';
      }
    } on SocketException {
      errorMessage = 'Can\'t connect to server';
    } on Exception {
      errorMessage = 'Some error occured';
    }
    updateStatus = Status.ERROR;
    return false;
  }

  Future<bool> updatePassword(
      {required String? email,
      required String randomPassword,
      required String newPassword}) async {
    updateStatus = Status.LOADING;
    try {
      final response = await http.put(
          Uri.https(API_BASE_URL, 'carnival/user/$email/password/reset'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(<String, String>{
            'random_password': randomPassword,
            'new_password': newPassword
          }));

      if (response.statusCode == HttpStatus.ok) {
        updateStatus = Status.SUCCESS;
        return true;
      } else if (response.statusCode == HttpStatus.badRequest) {
        errorMessage = 'Passwords can\'t be empty';
      } else if (response.statusCode == HttpStatus.notFound) {
        errorMessage = 'That email does not exist';
      } else {
        errorMessage = 'Temporary password doesn\'t match';
      }
    } on SocketException {
      errorMessage = 'Can\'t connect to server';
    } on Exception catch (e) {
      print(e);
      errorMessage = 'Some error occured';
    }

    updateStatus = Status.ERROR;
    return false;
  }

  Future<bool> fetchMovies(
      {required int page,
      bool isGenreSpecific = false,
      int? genreId,
      required String region,
      bool hardRefresh = false,
      bool shouldNotify = false}) async {
    if (!hardRefresh) {
      final box = Hive.box<MovieResponse>(movieResponseBox);
      final key = isGenreSpecific ? '${genreId}_movie' : 'top_movies';
      if (box.isNotEmpty && box.containsKey(key)) {
        //if (key != 'top_movies')

        curatedContent.add(box.get(key));
        _paginationFetchingStatus = PaginationFetchingStatus.idle;
        if (shouldNotify) notifyListeners();
        return true;
      }
    }
    final genres =
        !isGenreSpecific ? user!.getMovieGenreIds.join('|') : '$genreId';

    final watchProviders = user!.getWatchProviderIds.join('|');
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'workout_length': user!.getWorkoutLength.toString(),
        'genres': genres,
        'watch_providers': watchProviders,
        'watch_region': region
      };

      if (isGenreSpecific) {
        final withoutGenres = [];
        withoutGenres.addAll(user!.getMovieGenreIds);
        withoutGenres.removeWhere((element) => element == genreId.toString());
        queryParams['without_genres'] = withoutGenres.join(',');
      }

      final response = await http.get(
        Uri.https(API_BASE_URL, 'carnival/movies', queryParams),
      );
      if (response.statusCode == HttpStatus.ok) {
        dynamic decodedResponse = jsonDecode(response.body);
        var movieResponse;
        if (decodedResponse is Map<String, dynamic>) {
          movieResponse = MovieResponse.fromJson(decodedResponse);
        } else {
          movieResponse = MovieResponse();
        }

        movieResponse
          ..responseTitle = getTitlePhrase(
              categoryModel: movieResponse,
              category: WorkoutCategory.MOVIE,
              isGeneric: !isGenreSpecific,
              genre: genreId.toString(),
              user: user)
          ..isTopCategory = !isGenreSpecific;
        if (movieResponse != null) {
          final key = !isGenreSpecific ? 'top_movies' : '${genreId}_movie';

          if (movieResponse.movies != null &&
              movieResponse.movies!.isNotEmpty) {
            movieResponse.genre = key;
            await Hive.box<MovieResponse>(movieResponseBox)
                .put(key, movieResponse);
            curatedContent.add(movieResponse);
          } else {
            await Hive.box<MovieResponse>(movieResponseBox)
                .put(key, movieResponse);
            curatedContent.add(movieResponse);
            moviesTotalContentFilterCount++;
            contentToBeFiltered += 1;
          }
          _paginationFetchingStatus = PaginationFetchingStatus.idle;
          if (shouldNotify) notifyListeners();
          return true;
        }
      }
    } on SocketException catch (e) {
      print(e);
    } on Exception catch (e) {
      print(e);
    }
    final key = !isGenreSpecific ? 'top_movies' : '${genreId}_movie';
    await Hive.box<MovieResponse>(movieResponseBox).put(key, MovieResponse());
    curatedContent.add(MovieResponse());
    moviesTotalContentFilterCount++;
    contentToBeFiltered += 1;
    _paginationFetchingStatus = PaginationFetchingStatus.idle;
    if (shouldNotify) notifyListeners();
    return false;
  }

  Future<bool> fetchTVShows(
      {required int page,
      bool isGenreSpecific = false,
      int? genreId,
      required String region,
      bool hardRefresh = false,
      bool shouldNotify = false}) async {
    if (!hardRefresh) {
      final box = Hive.box<TVResponse>(tvResponseBox);
      final key = isGenreSpecific ? '${genreId}_tv' : 'top_tv_shows';
      if (box.isNotEmpty && box.containsKey(key)) {
        //if (key != 'top_tv_shows')
        curatedContent.add(box.get(key));
        _paginationFetchingStatus = PaginationFetchingStatus.idle;
        if (shouldNotify) notifyListeners();
        return true;
      }
    }
    final genres =
        !isGenreSpecific ? user!.getTvGenreIds.join('|') : '$genreId';
    final watchProviders = user!.getWatchProviderIds.join('|');
    try {
      final queryParams = {
        'page': page.toString(),
        'workout_length': user!.getWorkoutLength.toString(),
        'genres': genres,
        'watch_providers': watchProviders,
        'watch_region': region
      };

      if (isGenreSpecific) {
        final withoutGenres = [];
        withoutGenres.addAll(user!.getTvGenreIds);
        withoutGenres.removeWhere((element) => element == genreId.toString());
        queryParams['without_genres'] = withoutGenres.join(',');
      }

      final response = await http.get(
        Uri.https(API_BASE_URL, 'carnival/tv', queryParams),
      );

      if (response.statusCode == HttpStatus.ok) {
        dynamic decodedResponse = jsonDecode(response.body);
        var tvResponse;
        if (decodedResponse is Map<String, dynamic>) {
          tvResponse = TVResponse.fromJson(decodedResponse);
        } else {
          tvResponse = TVResponse();
        }
        tvResponse
          ..responseTitle = getTitlePhrase(
              categoryModel: tvResponse,
              category: WorkoutCategory.SHOW,
              isGeneric: !isGenreSpecific,
              genre: genreId.toString(),
              user: user)
          ..isTopCategory = !isGenreSpecific;

        final key = !isGenreSpecific ? 'top_tv_shows' : '${genreId}_tv';

        //saveTVResponseToDM(_tvResponse);
        if (tvResponse.tvShows != null && tvResponse.tvShows!.isNotEmpty) {
          tvResponse.genre = key;
          await Hive.box<TVResponse>(tvResponseBox).put(key, tvResponse);
          curatedContent.add(tvResponse);
        } else {
          await Hive.box<TVResponse>(tvResponseBox).put(key, tvResponse);
          curatedContent.add(tvResponse);
          showsTotalContentFilterCount++;
          contentToBeFiltered++;
        }

        _paginationFetchingStatus = PaginationFetchingStatus.idle;
        if (shouldNotify) notifyListeners();
        // notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    final key = !isGenreSpecific ? 'top_tv_shows' : '${genreId}_tv';
    await Hive.box<TVResponse>(tvResponseBox).put(key, TVResponse());
          curatedContent.add(TVResponse());
          showsTotalContentFilterCount++;
          contentToBeFiltered++;
    _paginationFetchingStatus = PaginationFetchingStatus.idle;
    if (shouldNotify) notifyListeners();
    return false;
  }

  Future<bool> fetchPodcasts(
      {@required String? genre,
      String region = 'US',
      bool hardRefresh = false,
      bool shouldNotify = false}) async {
    try {
      if (!hardRefresh) {
        final box = Hive.box<PodcastResponse>(podcastResponseBox);
        if (box.isNotEmpty && box.containsKey(genre)) {
          curatedContent.add(box.get(genre));
          _paginationFetchingStatus = PaginationFetchingStatus.idle;
          if (shouldNotify) notifyListeners();
          return true;
        }
      }
      final response = await http.get(
        Uri.https('open.spotify.com', 'genre/$genre'),
      );

      final spotifyTopGenresContent = response.body;
      final podcastsRegex =
          RegExp(r'{"spotify":"https://open.spotify.com/show/(.*?)"}');
      final matches = podcastsRegex.allMatches(spotifyTopGenresContent);
      final String podcastShowIds =
          matches.toList().map((match) => match.group(1)).join(',');

      int workoutLength = user!.getWorkoutLength;
      final showResponse = await http.get(Uri.https(
          API_BASE_URL,
          'carnival/podcasts/$podcastShowIds',
          {'region': region, 'workout_length': workoutLength.toString()}));
      if (showResponse.statusCode == HttpStatus.ok) {
        dynamic decodedResponse = jsonDecode(showResponse.body);
        var podcastResponse;
        if (decodedResponse is Map<String, dynamic>) {
          podcastResponse = PodcastResponse.fromJson(decodedResponse);
        } else {
          podcastResponse = PodcastResponse();
        }

        if ((podcastResponse.fiveMinpodcasts != null &&
                podcastResponse.fiveMinpodcasts.isNotEmpty) ||
            (podcastResponse.tenMinpodcasts != null &&
                podcastResponse.tenMinpodcasts.isNotEmpty) ||
            (podcastResponse.fifteenMinpodcasts != null &&
                podcastResponse.fifteenMinpodcasts.isNotEmpty) ||
            (podcastResponse.twentyMinpodcasts != null &&
                podcastResponse.twentyMinpodcasts.isNotEmpty)) {
          podcastResponse.genre = genre;
          await Hive.box<PodcastResponse>(podcastResponseBox)
              .put(genre, podcastResponse);
          curatedContent.add(podcastResponse);
        } else {
          await Hive.box<PodcastResponse>(podcastResponseBox)
              .put(genre, podcastResponse);
          curatedContent.add(podcastResponse);
          podcastsTotalContentFilterCount++;
          contentToBeFiltered++;
        }
        _paginationFetchingStatus = PaginationFetchingStatus.idle;
        if (shouldNotify) notifyListeners();
        return true;
        // curatedContent.add(podcastResponse);
        // notifyListeners();
        //saveCategoryToDB(podcasts, WorkoutCategory.PODCAST);
      }
    } on SocketException catch (e, s) {
      print(s);
    } on Exception catch (e, s) {
      print(s);
    }
    await Hive.box<PodcastResponse>(podcastResponseBox)
              .put(genre, PodcastResponse());
          curatedContent.add(PodcastResponse());
          podcastsTotalContentFilterCount++;
          contentToBeFiltered++;
    _paginationFetchingStatus = PaginationFetchingStatus.idle;
    if (shouldNotify) notifyListeners();
    return false;
  }

  Future<void> fetchInitialCategories(BuildContext? context,
      {String region = 'US', bool shouldHardRefresh = false}) async {
    // var maxInitialFetches = 0;
    paginationStatus = PaginationFetchingStatus.loading;
    var finalResult = true;
    isNetworkIssue = false;
    try {
      if (shouldHardRefresh) {
        await Hive.box<TVResponse>(tvResponseBox).clear();
        await Hive.box<MovieResponse>(movieResponseBox).clear();
        await Hive.box<PodcastResponse>(podcastResponseBox).clear();
        curatedContent.clear();
        contentToBeFiltered = 0;
        podcastsTotalContentFilterCount = 0;
        showsTotalContentFilterCount = 0;
        moviesTotalContentFilterCount = 0;
      }
      await updateUserPreferences(sampleUser, context,
          shouldUpdateStatus: false);

      if (sampleUser!.getIsTvChecked) {
        finalResult = finalResult &&
            await fetchTVShows(
                page: 1, region: region, hardRefresh: shouldHardRefresh);
        // maxInitialFetches =
        //     user!.getTvGenreIds.length > 1 ? 1 : user!.getTvGenreIds.length;
        // for (var i = 0; i < maxInitialFetches; i++) {
        //   await fetchTVShows(
        //       page: 1,
        //       region: region,
        //       isGenreSpecific: true,
        //       hardRefresh: shouldHardRefresh,
        //       genreId: int.parse(_user!.getTvGenreIds[i]));
        // }
      }
      if (sampleUser!.getIsMoviesChecked) {
        finalResult = finalResult &&
            await fetchMovies(
                page: 1, region: region, hardRefresh: shouldHardRefresh);
        // maxInitialFetches = user!.getMovieGenreIds.length > 1
        //     ? 1
        //     : user!.getMovieGenreIds.length;
        // for (var i = 0; i < maxInitialFetches; i++) {
        //   await fetchMovies(
        //       page: 1,
        //       region: region,
        //       hardRefresh: shouldHardRefresh,
        //       isGenreSpecific: true,
        //       genreId: int.parse(_user!.getMovieGenreIds[i]));
        // }
      }
      if (sampleUser!.getIsPodcastsChecked) {
        finalResult = finalResult &&
            await fetchPodcasts(
                hardRefresh: shouldHardRefresh,
                genre: user!.getPodcastGenres.first,
                region: region);
        // maxInitialFetches = user!.getPodcastGenres.length > 2
        //     ? 2
        //     : user!.getPodcastGenres.length;
        // for (var i = 0; i < maxInitialFetches; i++) {
        //   if (_user!.getPodcastGenres[i] == 'podcast-charts-body') continue;
        //   await fetchPodcasts(
        //       hardRefresh: shouldHardRefresh,
        //       region: region,
        //       genre: _user!.getPodcastGenres[i]);
        // }
      }

      notifyListeners();
      return;
    } catch (e, s) {
      print('Error - $e $s');
    }
    isNetworkIssue = true;
  }

  String getTitlePhrase(
      {required WorkoutCategory category,
      required User? user,
      String? genre,
      dynamic categoryModel,
      bool isGeneric = false}) {
    try {
      if (category == WorkoutCategory.SHOW) {
        if (isGeneric)
          //return 'Top rated shows in ${user!.getWorkoutLength} minutes';
          return 'Top rated shows';
        else
          //return '${TMDB_TV_GENRES[genre!]} shows you can watch in ${user!.getWorkoutLength} minutes';
          return '${TMDB_TV_GENRES[genre!]} shows for ${user!.getWorkoutLength} min workouts';
      } else if (category == WorkoutCategory.MOVIE) {
        if (isGeneric)
          return 'Top rated movies you can watch in ${user!.getWorkoutLength} min workouts';
        else
          //return '${TMDB_MOVIE_GENRES[genre!]} movies you can complete in ${((categoryModel as MovieResponse).averageRuntime! / user!.getWorkoutLength).ceil()} workouts';
          return '${TMDB_MOVIE_GENRES[genre!]} movies for ${user!.getWorkoutLength} min workouts';
      } else if (category == WorkoutCategory.PODCAST) {
        if (isGeneric)
          return 'Finish these podcasts in ${((categoryModel as PodcastResponse).averageRuntime! / user!.getWorkoutLength).ceil()} workouts';
        else
          return '${SPOTIFY_GENRES[genre!]} podcasts you can do in under ${((categoryModel as PodcastResponse).averageRuntime! / user!.getWorkoutLength).ceil()} workouts';
      }
    } catch (e) {}
    return '';
  }

  bool getIsCategoryFavourite(List favourites,
      {TV? tv, Movie? movie, Podcast? podcast}) {
    if (tv != null) {
      for (final fav in favourites) {
        if ((fav as TV).id == tv.id) return fav.getIsFavorite;
      }
    } else if (movie != null) {
      for (final fav in favourites) {
        if ((fav as Movie).id == movie.id) return fav.getIsFavorite;
      }
    } else if (podcast != null) {
      for (final fav in favourites) {
        if ((fav as Podcast).id == podcast.id) return fav.getIsFavorite;
      }
    } else
      throw StateError('All of the categories are null');
    return false;
  }

  void removeCategoryFromBox(
    int index,
    String mapKey,
    WorkoutCategory workoutCategory, {
    bool isFiveMinPodcast = false,
    bool isTenMinPodcast = false,
    bool isFifteenMinPodcast = false,
    bool isTwentyMinPodcast = false,
  }) {
    if (mapKey == "-1") return;
    if (workoutCategory == WorkoutCategory.SHOW)
      Hive.box<TVResponse>(tvResponseBox).get(mapKey)!.tvShows!.removeAt(index);
    else if (workoutCategory == WorkoutCategory.MOVIE)
      Hive.box<MovieResponse>(movieResponseBox)
          .get(mapKey)!
          .movies!
          .removeAt(index);
    else {
      isFiveMinPodcast
          ? Hive.box<PodcastResponse>(podcastResponseBox)
              .get(mapKey)!
              .fiveMinpodcasts!
              .removeAt(index)
          : isTenMinPodcast
              ? Hive.box<PodcastResponse>(podcastResponseBox)
                  .get(mapKey)!
                  .tenMinpodcasts!
                  .removeAt(index)
              : isFifteenMinPodcast
                  ? Hive.box<PodcastResponse>(podcastResponseBox)
                      .get(mapKey)!
                      .fifteenMinpodcasts!
                      .removeAt(index)
                  : Hive.box<PodcastResponse>(podcastResponseBox)
                      .get(mapKey)!
                      .twentyMinpodcasts!
                      .removeAt(index);
    }

    notifyListeners();
  }

  Future<bool> refreshTokenIfRequired(BuildContext context) async {
    try {
      final now = DateTime.now();
      final dateTime =
          now.subtract(Duration(minutes: user!.accessTokenCreatedAt!.minute));
      if (dateTime.minute - user!.accessTokenExpiresIn! ~/ 60 >= 4) {
        final response = await http
            .post(Uri.https(API_BASE_URL, 'carnival/refresh'), headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${user!.getRefreshToken}'
        });

        if (response.statusCode == HttpStatus.ok) {
          final tokenBody = jsonDecode(response.body);
          await saveUser(
              user!.copyWith(
                  accessToken: tokenBody['access_token'],
                  accessTokenExpiresIn: tokenBody['access_token_expires_in'],
                  accessTokenCreatedAt: DateTime.now()),
              shouldNotify: false);
          return true;
        } else if (response.statusCode == HttpStatus.unauthorized) {
          // Logout user.
          await Hive.box<User>(userBox).clear();
          await Hive.box<TVResponse>(tvResponseBox).clear();
          await Hive.box<MovieResponse>(movieResponseBox).clear();
          await Hive.box<PodcastResponse>(podcastResponseBox).clear();
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
        } else {
          return false;
        }
      } else
        return true;
    } catch (e) {}

    return false;
  }
}
