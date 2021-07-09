import 'package:curate_app/colors.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/home/home.dart';
import 'package:curate_app/screens/onboarding/onboarding_main.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class CarnivalApp extends StatelessWidget {
  final _splash = Container(
    height: double.infinity,
    width: double.infinity,
    color: fog,
    child: Center(child: SvgPicture.asset('assets/logo/logo.svg')),
  );
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appThemeData,
        home: _conditionalNavigate(userModel.user, userModel));
  }
}

final ThemeData _appThemeData = _buildAppTheme();

ThemeData _buildAppTheme() {
  ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: Colors.white,
      accentColor: royalBlue,
      buttonTheme: base.buttonTheme.copyWith(
          shape: StadiumBorder(),
          buttonColor: royalBlue,
          colorScheme: base.colorScheme.copyWith(secondary: royalBlue)),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      errorColor: violetRed,
      chipTheme: ChipThemeData(
          shape: StadiumBorder(),
          backgroundColor: royalBlue.withOpacity(0.15),
          disabledColor: Colors.grey,
          selectedColor: royalBlue.withOpacity(0.75),
          secondarySelectedColor: royalBlue.withOpacity(0.3),
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          labelStyle: _buildTextTheme(base.textTheme)
              .bodyText2!
              .copyWith(color: royalBlue),
          secondaryLabelStyle: base.chipTheme.secondaryLabelStyle,
          brightness: base.chipTheme.brightness),
      checkboxTheme:
          CheckboxThemeData(fillColor: MaterialStateProperty.all(royalBlue)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: StadiumBorder(),
              primary: royalBlue,
              onSurface: royalBlue,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              primary: royalBlue,
              side: BorderSide(color: royalBlue, width: 2),
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              shape: StadiumBorder(),
              primary: royalBlue,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16))),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: whisper,
          labelStyle: _buildTextTheme(base.textTheme)
              .bodyText2!
              .copyWith(color: mulledWine, fontWeight: FontWeight.normal),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          )));
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6!.copyWith(fontSize: 18.0),
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        bodyText2: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Poppins',
        displayColor: Colors.black,
        bodyColor: Colors.black,
      );
}

Widget _conditionalNavigate(User? user, UserModel userModel) {
  return user == null ||
          (!userModel.getIsGuest &&
              user.getEmail.isEmpty &&
              !user.getIsMoviesChecked &&
              !user.getIsPodcastsChecked &&
              !user.getIsTvChecked) ||
          (userModel.getIsGuest &&
              !user.getIsMoviesChecked &&
              !user.getIsPodcastsChecked &&
              !user.getIsTvChecked)
      ? OnboardingMain()
      : (!user.getIsMoviesChecked &&
              !user.getIsPodcastsChecked &&
              !user.getIsTvChecked)
          ? OnboardingWorkoutLengthPage()
          : (user.getPodcastGenres.isEmpty &&
                  user.getMovieGenreIds.isEmpty &&
                  user.getTvGenreIds.isEmpty)
              ? OnboardingWorkoutLengthPage()
              : (user.getWatchProviderIds.isEmpty
                  ? OnboardingWorkoutLengthPage()
                  : HomePage());
}
