import 'package:curate_app/constants.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/login/login.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../enums.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailNode = FocusNode();
  var _passwordText = '';
  final _passwordNode = FocusNode();
  var _obscureText = true;
  bool _showErrorBanner = false;
  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp lowerCaseRegex = RegExp(r'[a-z]');
  RegExp specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  bool passwordHasFocus = false;
  bool emailHasFocus = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
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

    _passwordController.addListener(() {
      setState(() {
        _passwordText = _passwordController.text;
      });
    });

    _passwordNode.addListener(() {
      setState(() {
        passwordHasFocus = _passwordNode.hasFocus;
      });
    });

    _emailNode.addListener(() {
      setState(() {
        emailHasFocus = _emailNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    "Sign up",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: emailHasFocus
                              ? Border.all(color: Colors.black, width: 2)
                              : Border.all(width: 0, color: whisper),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailNode,
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: emailHasFocus ? Colors.white : whisper,
                          labelText: "Email",
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: passwordHasFocus
                              ? Border.all(color: Colors.black, width: 2)
                              : Border.all(width: 0, color: whisper),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: TextField(
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        focusNode: _passwordNode,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                passwordHasFocus ? Colors.white : whisper,
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: mulledWine,
                              ),
                              onTap: () => togglePasswordVisibility(),
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
                  Row(
                    children: [
                      Text("Have an account?"),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => LoginPage())),
                        style: Theme.of(context)
                            .textButtonTheme
                            .style!
                            .copyWith(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0))),
                        child: Text("Login"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Consumer<UserModel>(builder: (context, user, child) {
                    return ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                                minimumSize: MaterialStateProperty.all(Size(
                                    MediaQuery.of(context).size.width / 2.5,
                                    0))),
                        onPressed: (!_passwordText.contains(lowerCaseRegex) ||
                              !_passwordText.contains(upperCaseRegex) ||
                              !_passwordText.contains(specialCharRegex) ||
                              _emailController.text.isEmpty) ? null : () {
                          _showErrorBanner = true;
                          final _user = user.signUp(
                              _emailController.text, _passwordController.text);
                          _user.then((currentUser) => currentUser != null &&
                                  user.getStatus == Status.SUCCESS
                              ? Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                  return OnboardingWorkoutLengthPage();
                                }), (route) => false)
                              : {});
                        },
                        child: user.getStatus == Status.LOADING
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)),
                              )
                            : Text("Get started"));
                  })
                ],
              )
            ],
          ),
          Consumer<UserModel>(builder: (context, userProvider, child) {
            return userProvider.getStatus == Status.ERROR && _showErrorBanner
                ? Container(
                    padding: EdgeInsets.all(8),
                    color: Theme.of(context).errorColor,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userProvider.getErrorMessage ??
                                'Some error occured',
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
          })
        ]),
      ),
    );
  }
}
