import 'package:curate_app/colors.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterListPage extends StatefulWidget {
  @override
  _FilterListPageState createState() => _FilterListPageState();
}

class _FilterListPageState extends State<FilterListPage> {
  bool? _isTVFilterChecked;
  bool? _isMovieFilterChecked;
  bool? _isPodcastFilterChecked;
  bool? showErrorBanner = false;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    final user = userModel.user;
    _isTVFilterChecked = user!.getIsTvChecked && user.getIsTvFilterChecked;
    _isMovieFilterChecked = user.getIsMoviesChecked && user.getIsMoviesFilterChecked;
    _isPodcastFilterChecked = user.getIsPodcastsChecked && user.getIsPodcastsFilterChecked;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final user = userModel.user;

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Filter List'),
              elevation: 0,
              leading: BackButton(
                color: Colors.black,
                onPressed: () async {
                  if (!_isMovieFilterChecked! &&
                      !_isTVFilterChecked! &&
                      !_isPodcastFilterChecked!) return;
                  await userModel.saveUser(
                      user!.copyWith(
                          isPodcastFilterChecked: _isPodcastFilterChecked,
                          isMovieFilterChecked: _isMovieFilterChecked,
                          isTvFilterChecked: _isTVFilterChecked),
                      shouldNotify: false);
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  showErrorBanner!
                      ? Container(
                          padding: EdgeInsets.all(8),
                          color: Theme.of(context).errorColor,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You need at least one!',
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
                                    onPressed: () => hideErrorBanner()),
                              ]))
                      : SizedBox(),
                  SizedBox(
                    height: 8,
                  ),
                  if (user!.getIsPodcastsChecked)
                    CheckboxListTile(
                        value: _isPodcastFilterChecked,
                        title: Text('Podcasts'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          setState(() {
                            _isPodcastFilterChecked = newValue;
                            if (!_isPodcastFilterChecked! &&
                                !_isMovieFilterChecked! &&
                                !_isTVFilterChecked!) {
                              showErrorBanner = true;
                            } else
                              showErrorBanner = false;
                          });
                        }),
                  if (user.getIsTvChecked)
                    CheckboxListTile(
                        value: _isTVFilterChecked,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('Shows/Series'),
                        onChanged: (newValue) {
                          setState(() {
                            _isTVFilterChecked = newValue;
                            if (!_isPodcastFilterChecked! &&
                                !_isMovieFilterChecked! &&
                                !_isTVFilterChecked!) {
                              showErrorBanner = true;
                            } else
                              showErrorBanner = false;
                          });
                        }),
                  if (user.getIsMoviesChecked)
                    CheckboxListTile(
                        value: _isMovieFilterChecked,
                        title: Text('Movies/Documentaries'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          setState(() {
                            _isMovieFilterChecked = newValue;
                            if (!_isPodcastFilterChecked! &&
                                !_isMovieFilterChecked! &&
                                !_isTVFilterChecked!) {
                              showErrorBanner = true;
                            } else
                              showErrorBanner = false;
                          });
                        }),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'To customize your list, go to the settings tab',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: mulledWine),
                      ))
                ],
              ),
            )),
        onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
    if (!_isMovieFilterChecked! &&
        !_isTVFilterChecked! &&
        !_isPodcastFilterChecked!) return false;

    final userModel = Provider.of<UserModel>(context, listen: false);
    await userModel.saveUser(
        userModel.user!.copyWith(
            isPodcastFilterChecked: _isPodcastFilterChecked,
            isMovieFilterChecked: _isMovieFilterChecked,
            isTvFilterChecked: _isTVFilterChecked),
        shouldNotify: false);
    return true;
  }

  void hideErrorBanner() {
    setState(() {
      showErrorBanner = false;
    });
  }
}
