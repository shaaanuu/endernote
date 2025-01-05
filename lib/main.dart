import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'api_key.dart';
import 'bloc/notes/note_bloc.dart';
import 'bloc/sync/sync_bloc.dart';
import 'models/note_model.dart';
import 'presentation/screens/about/screen_about.dart';
import 'presentation/screens/auth/screen_signin.dart';
import 'presentation/screens/auth/screen_signup.dart';
import 'presentation/screens/canvas/screen_canvas.dart';
import 'presentation/screens/favourite/screen_favourite.dart';
import 'presentation/screens/hero/screen_hero.dart';
import 'presentation/screens/home/home_new.dart';
import 'presentation/screens/home/screen_home.dart';
import 'presentation/screens/settings/screen_settings.dart';
import 'presentation/theme/endernote_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();
  late final String dirPath;

  if (Platform.isAndroid || Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    dirPath = dir.path;
  } else {
    final dir = await getApplicationSupportDirectory();
    dirPath = dir.path;
  }

  runApp(
    MyApp(
      isar: await Isar.open(
        [NoteModelSchema],
        directory: dirPath,
        inspector: false,
      ),
      idToken: await secureStorage.read(key: "idToken") ?? "",
      email: await secureStorage.read(key: "email") ?? "",
      localId: await secureStorage.read(key: "localId") ?? "",
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isar,
    required this.idToken,
    required this.email,
    required this.localId,
  });

  final Isar isar;
  final String idToken;
  final String email;
  final String localId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => NoteBloc(isar: isar),
        ),
        BlocProvider(
          create: (context) => SyncBloc(
            isar: isar,
            firebaseUrl: "$databaseURL/$localId/",
            apiKey: firebaseWebApi,
            idToken: idToken,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Endernote',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/canvas': (context) => ScreenCanvas(),
          '/home': (context) => const ScreenHome(),
          '/settings': (context) => const ScreenSettings(),
          '/about': (context) => const ScreenAbout(),
          '/favourite': (context) => const ScreenFavourite(),
          '/sign_in': (context) => ScreenSignIn(),
          '/sign_up': (context) => ScreenSignUp(),
          '/home2': (context) => const HomeNew(),
        },
        theme: enderNoteTheme,
        home: const ScreenHero(),
      ),
    );
  }
}
