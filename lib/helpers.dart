import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:curate_app/screens/signup/signup.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'enums.dart';
import 'models/movie.dart';
import 'models/notifiers/user_model.dart';
import 'models/podcast.dart';
import 'models/tv.dart';

void onPodcastFavouriteTap(
    Podcast podcast, BuildContext context, UserModel userModel) async {
  if (userModel.getIsGuest) {
    triggerCreateAnAccountSheet(context);
    return;
  }
  final updatedFavorites = userModel.user!.getFavorites!;
  final favPodcast = updatedFavorites['podcasts']
      .firstWhere((e) => e['id'] == podcast.id, orElse: () => null);
  final updatedPodcast = podcast.copyWith(favorite: true);
  if (favPodcast == null) {
    updatedFavorites['podcasts'].add(updatedPodcast.toJson());
  } else {
    final index = updatedFavorites['podcasts'].indexOf(favPodcast);
    updatedFavorites['podcasts'].removeAt(index);
  }
  final updatedUser = userModel.user!.copyWith(favorites: updatedFavorites);
  await userModel.saveUser(updatedUser);
  await userModel.updateUserPreferences(updatedUser, context,
      isFavorite: true,
      podcast: favPodcast == null ? updatedPodcast : podcast,
      shouldUpdateStatus: false);
}

void onTVFavouriteTap(TV tv, BuildContext context, UserModel userModel) async {
  if (userModel.getIsGuest) {
    triggerCreateAnAccountSheet(context);
    return;
  }
  final updatedFavorites = userModel.user!.getFavorites!;
  final tvShow = updatedFavorites['shows']
      .firstWhere((e) => e['id'] == tv.id, orElse: () => null);
  final updatedTV = tv.copyWith(favorite: true);
  if (tvShow == null) {
    updatedFavorites['shows'].add(updatedTV.toJson());
  } else {
    final index = updatedFavorites['shows'].indexOf(tvShow);
    updatedFavorites['shows'].removeAt(index);
  }
  final updatedUser = userModel.user!.copyWith(favorites: updatedFavorites);
  await userModel.saveUser(updatedUser);
  await userModel.updateUserPreferences(updatedUser, context,
      isFavorite: true,
      tv: tvShow == null ? updatedTV : tv,
      shouldUpdateStatus: false);
}

void onMovieFavouriteTap(
    Movie movie, BuildContext context, UserModel userModel) async {
  if (userModel.getIsGuest) {
    triggerCreateAnAccountSheet(context);
    return;
  }
  final updatedFavorites = userModel.user!.getFavorites!;
  final favMovie = updatedFavorites['movies']
      .firstWhere((e) => e['id'] == movie.id, orElse: () => null);
  final updatedMovie = movie.copyWith(favorite: true);
  if (favMovie == null) {
    updatedFavorites['movies'].add(updatedMovie.toJson());
  } else {
    final index = updatedFavorites['movies'].indexOf(favMovie);
    updatedFavorites['movies'].removeAt(index);
  }
  final updatedUser = userModel.user!.copyWith(favorites: updatedFavorites);
  await userModel.saveUser(updatedUser);
  await userModel.updateUserPreferences(updatedUser, context,
      isFavorite: true,
      movie: favMovie == null ? updatedMovie : movie,
      shouldUpdateStatus: false);
}

void triggerCreateAnAccountSheet(BuildContext context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      builder: (context) => Wrap(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close))),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Create an account',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'When you create a free account, you can favorite items and also let us know when you’ve already seen something.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.75),
                      )),
                  SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupPage())),
                    child: Text('Get started'),
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style!
                        .copyWith(
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 2, 0))),
                  ),
                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            )
          ]));
}

void triggerAwkwardSheet(BuildContext context) {
  showModalBottomSheet(
      isDismissible: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      builder: (context) => Wrap(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'This is Awkward',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'We couldn’t find anything that fit your workout window. Try updating your exercise time.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.75),
                      )),
                  SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => OnboardingWorkoutLengthPage(
                                isFromAwkwardSheet: true)),
                        (route) => false),
                    child: Text('Try again'),
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style!
                        .copyWith(
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 2, 0))),
                  ),
                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            )
          ]));
}

ProviderMetaData parseTMDBProviderData(
    UserModel? userModel, WorkoutCategory workoutCategory,
    {TV? tv, Movie? movie}) {
  String watchRegion =
      WidgetsBinding.instance!.window.locale.countryCode ?? 'US';

  dynamic watchProviders;
  if (workoutCategory == WorkoutCategory.SHOW)
    watchProviders = tv!.watchProviders;
  else
    watchProviders = movie!.watchProviders;

  if (watchProviders.isEmpty)
    return ProviderMetaData(
        providerId: -1, logoPath: '', name: 'multiple streaming services');

  if (watchProviders.containsKey(watchRegion))
    return findProvider(
        userModel: userModel,
        watchRegion: watchRegion,
        watchProviders: watchProviders,
        regionalProvider: watchProviders[watchRegion]);
  else if (watchRegion != 'US') {
    watchRegion = 'US';
    return findProvider(
        userModel: userModel,
        watchRegion: watchRegion,
        watchProviders: watchProviders,
        regionalProvider: watchProviders[watchRegion]);
  } else {
    // Bad. No could not pick current region provider or US region provider :(
    return ProviderMetaData(
        providerId: -1, logoPath: '', name: 'multiple streaming services');
  }
}

ProviderMetaData findProvider(
    {UserModel? userModel,
    String? watchRegion,
    dynamic watchProviders,
    dynamic regionalProvider}) {
  // We have atmost 5 monetization types. Let's iterate to find a provider chosen by user.
  if (regionalProvider == null) 
    return ProviderMetaData(
        providerId: -1, logoPath: '', name: 'multiple streaming services');
  for (final monetizationType in watchMonetizationTypes) {
    if (regionalProvider.containsKey(monetizationType)) {
      for (final currentProvider in regionalProvider[monetizationType]) {
        if (userModel!.user!.getWatchProviderIds
            .contains(currentProvider['provider_id'].toString())) {
          // Gotcha!
          return ProviderMetaData.fromJson(
              Map<String, dynamic>.from(currentProvider));
        }
      }
    }
  }

  // No watch providers :(
  return ProviderMetaData(
      providerId: -1, logoPath: '', name: 'multiple streaming services');
}
