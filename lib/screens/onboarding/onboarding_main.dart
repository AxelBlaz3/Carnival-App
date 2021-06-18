import 'package:curate_app/screens/login/login.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:curate_app/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              SvgPicture.asset('assets/logo/logo.svg'),
              SizedBox(
                height: 16,
              ),
              Text(
                "Carnival",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Curate content to keep you entertained while you workout",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ]),
            SizedBox(
              height: 80,
            ),
            Container(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    child: Text("Login"),
                    style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2, 24))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return SignupPage();
                        }));
                      },
                      child: Text("Signup"),
                      style: Theme.of(context)
                          .outlinedButtonTheme
                          .style!
                          .copyWith(
                              minimumSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width / 2, 24)))),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return OnboardingWorkoutLengthPage();
                      }));
                    },
                    child: Text("Skip for now"),
                    style: Theme.of(context).textButtonTheme.style!.copyWith(
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2, 24))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
