import 'package:curate_app/colors.dart';
import 'package:curate_app/enums.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/forgotpassword/forgot_password.dart';
import 'package:curate_app/screens/home/home.dart';
import 'package:curate_app/screens/onboarding/onboarding_workout_length.dart';
import 'package:curate_app/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  var _obscureText = true;
  bool _showErrorBanner = false;
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
                    "Login",
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
                  Row(
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SignupPage())),
                        style: Theme.of(context)
                            .textButtonTheme
                            .style!
                            .copyWith(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0))),
                        child: Text("Sign up"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Consumer<UserModel>(
                    builder: (context, user, child) {
                      return ElevatedButton(
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                  minimumSize: MaterialStateProperty.all(Size(
                                      MediaQuery.of(context).size.width / 2.5,
                                      0))),
                          onPressed: _emailController.text.isEmpty || _passwordController.text.isEmpty ? null : () {
                            _showErrorBanner = true;
                            final _user = user.loginUser(_emailController.text,
                                _passwordController.text);
                            _user.then((currentUser) => currentUser != null &&
                                    user.getStatus == Status.SUCCESS
                                ? (Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                    return ((currentUser.getIsMoviesChecked ||
                                                currentUser.getIsTvChecked ||
                                                currentUser
                                                    .getIsPodcastsChecked) &&
                                            (currentUser
                                                    .getMovieGenreIds.isNotEmpty ||
                                                currentUser
                                                    .getTvGenreIds.isNotEmpty ||
                                                currentUser.getPodcastGenres
                                                    .isNotEmpty) &&
                                            currentUser
                                                .getWatchProviderIds.isNotEmpty
                                        ? HomePage(
                                            hardRefresh: true,
                                          )
                                        : OnboardingWorkoutLengthPage());
                                  }), (route) => false))
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
                              : Text("Continue"));
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        }));
                      },
                      child: Text("Forgot password"))
                ],
              )
            ],
          ),
          Consumer<UserModel>(
            builder: (context, userProvider, child) {
              return AnimatedOpacity(
                  opacity:
                      userProvider.getStatus == Status.ERROR && _showErrorBanner
                          ? 1.0
                          : 0.0,
                  duration: Duration(milliseconds: 250),
                  child: Container(
                      padding: EdgeInsets.all(8),
                      color: Theme.of(context).errorColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userProvider.getErrorMessage ?? '',
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
                          ])));
            },
          ),
        ]),
      ),
    );
  }
}
