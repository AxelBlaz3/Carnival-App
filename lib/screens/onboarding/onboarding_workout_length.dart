import 'package:curate_app/colors.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/home/home.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingWorkoutLengthPage extends StatefulWidget {
  bool isFromPreferences = false;
  bool isFromAwkwardSheet = false;

  OnboardingWorkoutLengthPage(
      {bool isFromPreferences = false, bool isFromAwkwardSheet = false}) {
    this.isFromPreferences = isFromPreferences;
    this.isFromAwkwardSheet = isFromAwkwardSheet;
  }

  @override
  _OnboardingWorkoutLengthPageState createState() =>
      _OnboardingWorkoutLengthPageState(
          isFromPreferences: isFromPreferences,
          isFromAwkwardSheet: isFromAwkwardSheet);
}

class _OnboardingWorkoutLengthPageState
    extends State<OnboardingWorkoutLengthPage> {
  bool isFromPreferences = false;
  int? workoutLength = 20;
  bool isFromAwkwardSheet = false;

  _OnboardingWorkoutLengthPageState(
      {bool isFromPreferences = false, bool isFromAwkwardSheet = false}) {
    this.isFromPreferences = isFromPreferences;
    this.isFromAwkwardSheet = isFromAwkwardSheet;
  }

  @override
  void initState() {
    super.initState();
    workoutLength = Provider.of<UserModel>(context, listen: false)
        .sampleUser!
        .getWorkoutLength;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final pastWorkoutLength = userModel.user!.getWorkoutLength;

    return Scaffold(
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(24), children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              Text(
                "How many minutes do you typically workout?",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: mulledWine, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 64,
                      height: 64,
                      child: CircleAvatar(
                          backgroundColor: whisper,
                          child: IconButton(
                              icon: Icon(Icons.remove, color: Colors.black),
                              onPressed: () {
                                if (userModel.sampleUser!.getWorkoutLength > 0)
                                  setState(() {
                                    workoutLength = workoutLength! - 1;
                                  });
                              }))),
                  Text('$workoutLength',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(
                      width: 64,
                      height: 64,
                      child: CircleAvatar(
                          backgroundColor: whisper,
                          child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  workoutLength = workoutLength! + 1;
                                });
                              }))),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 0))),
                  onPressed: userModel.sampleUser!.getWorkoutLength <= 0
                      ? null
                      : () async {
                          await userModel.saveUser(userModel.sampleUser!
                              .copyWith(workoutLength: workoutLength));
                          if (isFromPreferences || isFromAwkwardSheet)
                            userModel
                              ..contentToBeFiltered = 0
                              ..showsTotalContentFilterCount = 0
                              ..podcastsTotalContentFilterCount = 0
                              ..moviesTotalContentFilterCount = 0;
                          if (!isFromPreferences)
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OnboardingWorkoutTypePage(
                                isFromPreferences: isFromAwkwardSheet,
                              );
                            }));
                          else
                            await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          hardRefresh: isFromPreferences &&
                                              pastWorkoutLength !=
                                                  userModel.sampleUser!
                                                      .getWorkoutLength,
                                        )),
                                (Route<dynamic> route) => false);
                        },
                  child: Text("Continue"))
            ],
          )
        ]),
      ),
    );
  }
}
