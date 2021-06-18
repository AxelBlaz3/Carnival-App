import 'package:curate_app/constants.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:curate_app/models/user.dart';
import 'package:curate_app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../enums.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() =>
      _ResetPasswordPageState(email: this.email);
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final String? email;
  _ResetPasswordPageState({required this.email});

  final _randomPasswordContoller = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _randomPassNode = FocusNode();
  final _newPassNode = FocusNode();
  bool randomPassHasFocus = false;
  bool newPassHasFocus = false;
  var _randomPassObscureText = true;
  var _newPassObscureText = true;
  var _showErrorBanner = false;

  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp lowerCaseRegex = RegExp(r'[a-z]');
  RegExp specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  var _passwordText = '';

  void togglePasswordVisibility({required isRandomPasswordField}) {
    setState(() {
      if (isRandomPasswordField)
        _randomPassObscureText = !_randomPassObscureText;
      else
        _newPassObscureText = !_newPassObscureText;
    });
  }

  void hideErrorBanner() {
    setState(() {
      _showErrorBanner = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _newPassNode.addListener(() {
      setState(() {
        newPassHasFocus = _newPassNode.hasFocus;
      });
    });

    _newPasswordController.addListener(() {
      setState(() {
        _passwordText = _newPasswordController.text;
      });
    });

    _randomPassNode.addListener(() {
      setState(() {
        randomPassHasFocus = _randomPassNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          ListView(
            padding: EdgeInsets.all(24),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4.5,
                  ),
                  Text(
                    "Reset password",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Enter the random password that you received in your mail along with your new password.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: randomPassHasFocus
                              ? Border.all(color: Colors.black, width: 2)
                              : Border.all(width: 0, color: whisper),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: TextField(
                        obscureText: _randomPassObscureText,
                        focusNode: _randomPassNode,
                        controller: _randomPasswordContoller,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                randomPassHasFocus ? Colors.white : whisper,
                            labelText: "Temporary password",
                            suffixIcon: GestureDetector(
                              child: Icon(
                                _randomPassObscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: mulledWine,
                              ),
                              onTap: () => togglePasswordVisibility(
                                  isRandomPasswordField: true),
                            )),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: newPassHasFocus
                              ? Border.all(color: Colors.black, width: 2)
                              : Border.all(width: 0, color: whisper),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: TextField(
                        obscureText: _newPassObscureText,
                        keyboardType: TextInputType.visiblePassword,
                        focusNode: _newPassNode,
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: newPassHasFocus ? Colors.white : whisper,
                            labelText: "New Password",
                            suffixIcon: GestureDetector(
                              child: Icon(
                                _randomPassObscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: mulledWine,
                              ),
                              onTap: () => togglePasswordVisibility(
                                  isRandomPasswordField: false),
                            )),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Minimum of 8 characters",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: _passwordText.length >= 8
                                ? caribbeanGreen
                                : cadetBlue,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "At least one upper case character",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: _passwordText.contains(upperCaseRegex)
                                ? caribbeanGreen
                                : cadetBlue,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "At least one lower case character",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: _passwordText.contains(lowerCaseRegex)
                                ? caribbeanGreen
                                : cadetBlue,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "At least one special character",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: _passwordText.contains(specialCharRegex)
                                ? caribbeanGreen
                                : cadetBlue,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 56,
                  ),
                  Consumer<UserModel>(
                    builder: (context, userModel, child) {
                      return ElevatedButton(
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                  minimumSize: MaterialStateProperty.all(Size(
                                      MediaQuery.of(context).size.width / 2.5,
                                      0))),
                          onPressed: () {
                            if (!_passwordText.contains(lowerCaseRegex) ||
                                !_passwordText.contains(upperCaseRegex) ||
                                !_passwordText.contains(specialCharRegex))
                              return null;
                            _showErrorBanner = true;
                            final resetPassword = userModel.updatePassword(
                                email: email,
                                randomPassword: _randomPasswordContoller.text,
                                newPassword: _newPasswordController.text);
                            resetPassword.then((isPasswordReset) =>
                                isPasswordReset &&
                                        userModel.getStatus == Status.SUCCESS
                                    ? cleanupCacheAndNavigateToLogin()
                                    : {});
                          },
                          child: userModel.getStatus == Status.LOADING
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)),
                                )
                              : Text("Reset"));
                    },
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              )
            ],
          ),
          Consumer<UserModel>(
            builder: (context, userProvider, child) {
              return userProvider.getStatus == Status.ERROR && _showErrorBanner
                  ? Container(
                      padding: EdgeInsets.all(8),
                      color: Theme.of(context).errorColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userProvider.getErrorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.white),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () => hideErrorBanner())
                          ]))
                  : SizedBox.shrink();
            },
          )
        ]),
      ),
    );
  }

  void cleanupCacheAndNavigateToLogin() async {
    await Hive.box<User>(userBox).clear();
    await Hive.box<TVResponse>(tvResponseBox).clear();
    await Hive.box<MovieResponse>(movieResponseBox).clear();
    await Hive.box<PodcastResponse>(podcastResponseBox).clear();
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
      return LoginPage();
    }), (Route<dynamic> route) => false);
  }
}
