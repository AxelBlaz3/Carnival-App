import 'dart:convert';

import 'package:curate_app/app.dart';
import 'package:curate_app/constants.dart';
import 'package:curate_app/models/movie.dart';
import 'package:curate_app/models/podcast.dart';
import 'package:curate_app/models/tv.dart';
import 'package:curate_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/notifiers/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(ProductionCountryAdapter());
  Hive.registerAdapter(WatchProviderAdapter());
  Hive.registerAdapter(TVAdapter());
  Hive.registerAdapter(TVResponseAdapter());
  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(MovieResponseAdapter());
  Hive.registerAdapter(PodcastImageAdapter());
  Hive.registerAdapter(PodcastAdapter());
  Hive.registerAdapter(PodcastResponseAdapter());

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }

  var encryptionKey = base64Url.decode((await secureStorage.read(key: 'key'))!);

  await Hive.openBox<User>(userBox,
      encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox<TVResponse>(tvResponseBox);
  await Hive.openBox<MovieResponse>(movieResponseBox);
  await Hive.openBox<PodcastResponse>(podcastResponseBox);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserModel())],
      child: CarnivalApp()));
}
