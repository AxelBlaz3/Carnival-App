import 'package:curate_app/colors.dart';
import 'package:curate_app/constants.dart';
import 'package:curate_app/models/notifiers/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';

class OnboardingStreamingServicesPage extends StatefulWidget {
  bool? isFromPreferences;

  OnboardingStreamingServicesPage({bool? isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences;
  }

  @override
  _OnboardingStreamingServicesPageState createState() =>
      _OnboardingStreamingServicesPageState(
          isFromPreferences: isFromPreferences);
}

class _OnboardingStreamingServicesPageState
    extends State<OnboardingStreamingServicesPage> {
  bool? isFromPreferences;

  _OnboardingStreamingServicesPageState({bool? isFromPreferences = false}) {
    this.isFromPreferences = isFromPreferences;
  }

  // @override
  // void initState() {
  //   _searchController.addListener(() {
  //     onSearchTextChanged();
  //   });
  //   super.initState();
  // }

  // final _searchController = TextEditingController();

  List<String> _searchedLabels = [];
  List<String> watchProviderIds = [];

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    watchProviderIds = userModel.sampleUser!.getWatchProviderIds;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Stack(children: [
        ListView(
          padding: EdgeInsets.all(24),
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              "Last question, which streaming services do you use?",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: mulledWine, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24,
            ),
            // TextField(
            //   //controller: _searchController,
            //   decoration: InputDecoration(
            //       labelText: 'Search',
            //       prefixIcon: Padding(
            //           padding: EdgeInsets.all(16),
            //           child: SvgPicture.asset('assets/icon/search.svg'))),
            // ),
            // SizedBox(
            //   height: 24,
            // ),
            // _searchController.text.isNotEmpty && _searchedLabels.isNotEmpty
            //     ? Wrap(
            //         spacing: 8,
            //         children: _buildChips(chipLabels: _searchedLabels))
            //     : (_searchController.text.isNotEmpty && _searchedLabels.isEmpty
            //         ? Container(
            //             margin: EdgeInsets.only(top: 16),
            //             child: Text(
            //               "Sorry, we don’t feature that ... yet",
            //               textAlign: TextAlign.center,
            //               style: Theme.of(context).textTheme.headline6!.copyWith(
            //                   color: cadetBlue, fontWeight: FontWeight.bold),
            //             )) :
            Wrap(
                spacing: 8,
                children: _buildChips(
                    chipLabels: TMDB_MOVIE_WATCH_PROVIDERS.values.toList())),

            SizedBox(
              height: 32,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  'We’re working on adding more 🤞',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: mulledWine, fontWeight: FontWeight.w600),
                )),
            SizedBox(
              height: 16,
            ),
          ],
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(
                horizontal: deviceSize.width / 4.5, vertical: 48),
            child: Consumer<UserModel>(
                builder: (context, userModel, child) => ElevatedButton(
                      onPressed: watchProviderIds.isEmpty
                          ? null
                          : () => navigateToNextScreen(context, userModel),
                      child: Text("Continue"),
                      style: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .copyWith(
                              minimumSize: MaterialStateProperty.all(
                                  Size(deviceSize.width / 2.5, 0))),
                    )))
      ])),
    );
  }

  List<Widget> _buildChips({required List<String> chipLabels}) {
    return List.generate(chipLabels.length, (index) {
      return Consumer<UserModel>(
          builder: (context, userModel, child) => ChoiceChip(
                label: Text(chipLabels[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: royalBlue)),
                selected: watchProviderIds
                    .contains(TMDB_MOVIE_WATCH_PROVIDERS.keys.elementAt(index)),
                onSelected: (value) async {
                  if (value) {
                    setState(() {
                      watchProviderIds.add(
                          TMDB_MOVIE_WATCH_PROVIDERS.keys.elementAt(index));
                    });
                  } else {
                    setState(() {
                      watchProviderIds.remove(
                          TMDB_MOVIE_WATCH_PROVIDERS.keys.elementAt(index));
                    });
                  }
                },
              ));
    }).toList();
  }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  // void onSearchTextChanged() async {
  //   if (_searchController.text.isEmpty) {
  //     setState(() {
  //       _searchedLabels.clear();
  //     });
  //     return;
  //   }

  //   _searchedLabels.clear();
  //   TMDB_MOVIE_WATCH_PROVIDERS.values.toList().forEach((element) {
  //     if (element
  //         .toLowerCase()
  //         .startsWith(_searchController.text.toLowerCase())) {
  //       _searchedLabels.add(element);
  //     }
  //   });

  //   setState(() {});
  // }

  void navigateToNextScreen(BuildContext context, UserModel userModel) async {
    await userModel.saveUser(
        userModel.sampleUser!.copyWith(watchProviderIds: watchProviderIds));
    userModel
      ..contentToBeFiltered = 0
      ..showsTotalContentFilterCount = 0
      ..podcastsTotalContentFilterCount = 0
      ..moviesTotalContentFilterCount = 0;
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  hardRefresh: isFromPreferences!,
                )),
        (route) => false);
  }
}
