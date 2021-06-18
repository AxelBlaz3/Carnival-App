import 'package:curate_app/colors.dart';
import 'package:curate_app/constants.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:curate_app/models/user.dart';
import 'package:curate_app/screens/login/login.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_type.dart';
import 'package:curate_app/screens/settings/account.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _preferenceTitles = [
    'My account',
    'Average workout duration',
    'Content preference',
    'Feedback'
  ];

  bool isGuest = false;

  final userBoxStore = Hive.box<User>(userBox);

  @override
  void initState() {
    super.initState();

    final userModel = Provider.of<UserModel>(context, listen: false);
    isGuest = userModel.getIsGuest;
    if (isGuest) _preferenceTitles.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Settings & Preferences'),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: _preferenceTitles.length * 2,
                  itemBuilder: (context, index) {
                    if (index.isOdd) return Divider();

                    return ListTile(
                      title: Text(_preferenceTitles[index ~/ 2]),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                      ),
                      onTap: () {
                        if (!isGuest) {
                          switch (index) {
                            case 0:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AccountPage()));
                              break;
                            case 2:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OnboardingWorkoutLengthPage(
                                        isFromPreferences: true,
                                      )));
                              break;
                            case 4:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OnboardingWorkoutTypePage(
                                        isFromPreferences: true,
                                      )));
                              break;
                            case 6:
                              _launchFeedbackForm();
                              break;
                            default:
                          }
                        } else {
                          switch (index) {
                            case 0:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OnboardingWorkoutLengthPage(
                                        isFromPreferences: true,
                                      )));
                              break;
                            case 2:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OnboardingWorkoutTypePage(
                                        isFromPreferences: true,
                                      )));
                              break;
                            case 4:
                              _launchFeedbackForm();
                              break;
                            default:
                          }
                        }
                      },
                    );
                  })),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () async {
                  await Hive.box<User>(userBox).clear();
                    await Hive.box<TVResponse>(tvResponseBox).clear();
                    await Hive.box<MovieResponse>(movieResponseBox).clear();
                    await Hive.box<PodcastResponse>(podcastResponseBox).clear();
                  
                  if (!isGuest) {
                    await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                    return;
                  } else {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
                child: Text(isGuest ? 'Login' : 'Sign out'),
                style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2, 0))),
              ),
              Spacer(),
              Container(
                  margin: EdgeInsets.all(24),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Version number: 1.0',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: cadetBlue),
                  ))
            ],
          )),
        ]),
      ),
    );
  }

  void _launchFeedbackForm() async {
    await canLaunch(feedbackFormUrl)
        ? await launch(feedbackFormUrl,
            forceWebView: true, enableJavaScript: true)
        : throw 'Could not launch $feedbackFormUrl';
  }
}
