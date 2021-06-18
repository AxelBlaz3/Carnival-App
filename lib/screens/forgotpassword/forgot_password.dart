import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/forgotpassword/email_sent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../enums.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _emailNode = FocusNode();
  var _showErrorBanner = false;
  bool emailHasFocus = false;

  void hideErrorBanner() {
    setState(() {
      _showErrorBanner = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _emailNode.addListener(() {
      setState(() {
        emailHasFocus = _emailNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

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
                  "Forgot password",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Enter the email associated with your account',
                  style: Theme.of(context).textTheme.bodyText2,
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
                  height: 48,
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
                        onPressed: () {
                          _showErrorBanner = true;
                          final sendEmail = userModel
                              .sendRandomPasswordToEmail(_emailController.text);
                          sendEmail.then((isEmailSent) =>
                              isEmailSent && user.getStatus == Status.SUCCESS
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return EmailSentPage(
                                        email: _emailController.text,
                                      );
                                    }))
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
    ));
  }
}
