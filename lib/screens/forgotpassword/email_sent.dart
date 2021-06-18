import 'package:curate_app/colors.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:curate_app/screens/forgotpassword/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums.dart';

class EmailSentPage extends StatefulWidget {
  final String? email;

  const EmailSentPage({Key? key, this.email}) : super(key: key);

  @override
  _EmailSentPageState createState() => _EmailSentPageState(email: email);
}

class _EmailSentPageState extends State<EmailSentPage> {
  final String? email;

  _EmailSentPageState({required this.email});

  var _showBanner = false;

  void hideBanner() {
    setState(() {
      _showBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      ListView(
        padding: EdgeInsets.all(24),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          Column(children: [
            Text(
              "Check your email! 🤞",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'We’ve sent you a temporary password to use',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ]),
          SizedBox(
            height: 48,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4.5),
            child: ElevatedButton(onPressed: () {
              userModel.getStatus != Status.LOADING
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return ResetPasswordPage(email: email,);
                    }))
                  : {};
            }, child: Consumer<UserModel>(builder: (context, userModel, child) {
              return userModel.getStatus == Status.LOADING
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Text('Continue');
            })),
          ),
          SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () {
                _showBanner = true;
                userModel.sendRandomPasswordToEmail(email!);
              },
              child: Text("Send again"))
        ],
      ),
      Consumer<UserModel>(
        builder: (context, userProvider, child) {
          return userModel.getStatus != Status.LOADING && _showBanner
              ? Container(
                  padding: EdgeInsets.all(8),
                  color: userModel.getStatus == Status.SUCCESS ? Theme.of(context).accentColor : violetRed,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userModel.getStatus == Status.SUCCESS ? 'Email has been sent' : userModel.getErrorMessage!,
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
                            onPressed: () => hideBanner())
                      ]))
              : SizedBox.shrink();
        },
      )
    ])));
  }
}
