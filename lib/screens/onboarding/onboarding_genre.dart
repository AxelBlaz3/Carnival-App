import 'package:curate_app/colors.dart';
import 'package:curate_app/constants.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/home/home.dart';
import 'package:curate_app/screens/onboarding/onboarding_streaming_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums.dart';

class OnboardingGenrePage extends StatefulWidget {
  OnboardingGenrePage({Key? key, isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences;
  }
  bool? isFromPreferences;

  @override
  _OnboardingGenrePageState createState() =>
      _OnboardingGenrePageState(isFromPreferences: this.isFromPreferences);
}

class _OnboardingGenrePageState extends State<OnboardingGenrePage> {
  bool? isFromPreferences;
  bool cannotNavigate = true;
  var tvGenreIds = <String>[];
  var movieGenreIds = <String>[];
  var podcastGenres = <String>[];

  _OnboardingGenrePageState({isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences;
  }

  @override
  void initState() {
    super.initState();

    final userModel = Provider.of<UserModel>(context, listen: false);
    tvGenreIds = userModel.sampleUser!.getTvGenreIds;
    movieGenreIds = userModel.sampleUser!.getMovieGenreIds;
    podcastGenres = userModel.sampleUser!.getPodcastGenres;
    cannotNavigate = isAbleToNavigate(userModel);
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
            child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    "What genre’s do you like?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold, color: mulledWine),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  userModel.user!.getIsPodcastsChecked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Podcasts',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: mulledWine,
                                      fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Wrap(
                                spacing: 8,
                                children: _buildChips(
                                    context,
                                    SPOTIFY_GENRES.values.toList(),
                                    WorkoutCategory.PODCAST,
                                    userModel)),
                          ],
                        )
                      : SizedBox.shrink(),
                  userModel.user!.getIsTvChecked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Shows/Series',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: mulledWine,
                                      fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Wrap(
                                spacing: 8,
                                children: _buildChips(
                                    context,
                                    TMDB_TV_GENRES.values.toList(),
                                    WorkoutCategory.SHOW,
                                    userModel)),
                          ],
                        )
                      : SizedBox.shrink(),
                  userModel.user!.getIsMoviesChecked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Movies/Documentaries',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: mulledWine,
                                      fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Wrap(
                                spacing: 8,
                                children: _buildChips(
                                    context,
                                    TMDB_MOVIE_GENRES.values.toList(),
                                    WorkoutCategory.MOVIE,
                                    userModel)),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 96,
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 48),
                child: ElevatedButton(
                  onPressed: cannotNavigate
                      ? null
                      : () => navigateToNextScreen(context, userModel),
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize: MaterialStateProperty.all(
                          Size(deviceWidth / 2.5, 0))),
                  // backgroundColor: MaterialStateProperty.all(
                  //     cannotNavigate ? royalBlue.withOpacity(0.7) : royalBlue)),
                  child: Text("Continue"),
                )),
          ],
        )));
  }

  List<Widget> _buildChips(BuildContext context, List<String> chipLabels,
      WorkoutCategory category, UserModel userModel) {
    return List.generate(
      chipLabels.length,
      (index) => Consumer<UserModel>(
          builder: (context, value, child) => ChoiceChip(
                selected: category == WorkoutCategory.MOVIE
                    ? movieGenreIds
                        .contains(TMDB_MOVIE_GENRES.keys.elementAt(index))
                    : (category == WorkoutCategory.PODCAST
                        ? podcastGenres
                            .contains(SPOTIFY_GENRES.keys.elementAt(index))
                        : tvGenreIds
                            .contains(TMDB_TV_GENRES.keys.elementAt(index))),
                onSelected: (value) async {
                  if (value) {
                    if (category == WorkoutCategory.MOVIE) {
                      setState(() {
                        movieGenreIds
                            .add(TMDB_MOVIE_GENRES.keys.elementAt(index));
                      });
                    } else if (category == WorkoutCategory.PODCAST) {
                      podcastGenres.add(SPOTIFY_GENRES.keys.elementAt(index));
                    } else {
                      tvGenreIds.add(TMDB_TV_GENRES.keys.elementAt(index));
                    }
                  } else {
                    if (category == WorkoutCategory.MOVIE) {
                      setState(() {
                        movieGenreIds
                            .remove(TMDB_MOVIE_GENRES.keys.elementAt(index));
                      });
                    } else if (category == WorkoutCategory.PODCAST) {
                      setState(() {
                        podcastGenres
                            .remove(SPOTIFY_GENRES.keys.elementAt(index));
                      });
                    } else {
                      setState(() {
                        tvGenreIds.remove(TMDB_TV_GENRES.keys.elementAt(index));
                      });
                    }
                  }
                  isAbleToNavigate(userModel);
                },
                label: Text(
                  chipLabels[index],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: royalBlue),
                ),
                avatar: Icon(
                  Icons.local_offer_outlined,
                  size: 16,
                  color: royalBlue,
                ),
              )),
    ).toList();
  }

  void navigateToNextScreen(BuildContext context, UserModel userModel) async {
    await userModel.saveUser(userModel.sampleUser!.copyWith(
        movieGenreIds: movieGenreIds,
        seriesGenreIds: tvGenreIds,
        podcastGenres: podcastGenres));
    if (userModel.sampleUser!.getIsMoviesChecked ||
        userModel.sampleUser!.getIsTvChecked) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OnboardingStreamingServicesPage(
            isFromPreferences: isFromPreferences);
      }));
    } else {
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
          HomePage(hardRefresh: isFromPreferences!)), (route) => false);
    }
  }

  bool isAbleToNavigate(UserModel userModel) {
    setState(() {
      cannotNavigate = (userModel.sampleUser!.getIsMoviesChecked &&
              movieGenreIds.isEmpty) ||
          (userModel.sampleUser!.getIsTvChecked && tvGenreIds.isEmpty) ||
          (userModel.sampleUser!.getIsPodcastsChecked && podcastGenres.isEmpty);
    });
    return cannotNavigate;
  }
}
