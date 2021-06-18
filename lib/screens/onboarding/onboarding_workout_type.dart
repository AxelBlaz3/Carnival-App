import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/home/home.dart';
import 'package:curate_app/screens/onboarding/onboarding_genre.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';

class OnboardingWorkoutTypePage extends StatefulWidget {
  bool? isFromPreferences;

  OnboardingWorkoutTypePage({bool? isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences;
  }

  @override
  _OnboardingWorkoutTypePageState createState() =>
      _OnboardingWorkoutTypePageState(isFromPreferences: isFromPreferences);
}

class _OnboardingWorkoutTypePageState extends State<OnboardingWorkoutTypePage> {
  bool? isFromPreferences;
  bool? _isMoviesChecked = false;
  bool? _isTVChecked = false;
  bool? _isPodcastChecked = false;

  _OnboardingWorkoutTypePageState({bool? isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences!;
  }

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    _isMoviesChecked = userModel.user!.getIsMoviesChecked;
    _isTVChecked = userModel.user!.getIsTvChecked;
    _isPodcastChecked = userModel.user!.getIsPodcastsChecked;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(24), children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Text(
                "What type of content do you like to workout to?",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: mulledWine, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 48,
              ),
              CheckboxListTile(
                  value: _isPodcastChecked,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Podcasts',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: mulledWine),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _isPodcastChecked = newValue;
                    });
                  }),
              CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isTVChecked,
                  title: Text(
                    'Shows/Series',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: mulledWine),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _isTVChecked = newValue;
                    });
                  }),
              CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isMoviesChecked,
                  title: Text(
                    'Movies/Documentaries',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: mulledWine),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _isMoviesChecked = newValue;
                    });
                  }),
              SizedBox(
                height: 48,
              ),
              ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 0))),
                  onPressed: !_isPodcastChecked! &&
                          !_isTVChecked! &&
                          !_isMoviesChecked!
                      ? null
                      : () => navigateToNextScreen(userModel),
                  child: Text('Continue'))
            ],
          ),
        ]),
      ),
    );
  }

  void navigateToNextScreen(UserModel userModel) async {
    await userModel.saveUser(userModel.sampleUser!.copyWith(
        isMoviesChecked: _isMoviesChecked,
        isTvChecked: _isTVChecked,
        isPodcastsChecked: _isPodcastChecked));
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OnboardingGenrePage(
        isFromPreferences: isFromPreferences,
      );
    }));
  }
}
