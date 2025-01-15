import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'api_key.dart';
import 'bloc/directory/directory_bloc.dart';
import 'bloc/directory/directory_events.dart';
import 'bloc/sync/sync_bloc.dart';
import 'presentation/screens/about/screen_about.dart';
import 'presentation/screens/auth/screen_signin.dart';
import 'presentation/screens/auth/screen_signup.dart';
import 'presentation/screens/canvas/screen_canvas.dart';
import 'presentation/screens/hero/screen_hero.dart';
import 'presentation/screens/home/screen_home.dart';
import 'presentation/screens/settings/screen_settings.dart';
import 'presentation/theme/endernote_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();

  Future<String> fetchRootPath() async {
    late final String path;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final directory = await getApplicationDocumentsDirectory();
      path = '${directory.path}/Endernote';
    } else {
      final directory = await getExternalStorageDirectory();
      path = '${directory!.path}/Endernote';
    }

    final folder = Directory(path);

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    return folder.path;
  }

  runApp(
    MyApp(
      idToken: await secureStorage.read(key: "idToken") ?? "",
      email: await secureStorage.read(key: "email") ?? "",
      localId: await secureStorage.read(key: "localId") ?? "",
      rootPath: await fetchRootPath(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.idToken,
    required this.email,
    required this.localId,
    required this.rootPath,
  });

  final String idToken;
  final String email;
  final String localId;
  final String rootPath;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SyncBloc(
            localNotesDirectory: rootPath,
            firebaseUrl: "$databaseURL/$localId",
            // apiKey: firebaseWebApi,
            // idToken: idToken,
          ),
        ),
        BlocProvider<DirectoryBloc>(
          create: (_) => DirectoryBloc()..add(FetchDirectory(rootPath)),
        ),
      ],
      child: MaterialApp(
        title: 'Endernote',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/canvas': (context) => ScreenCanvas(),
          '/home': (context) => ScreenHome(rootPath: rootPath),
          '/settings': (context) => const ScreenSettings(),
          '/about': (context) => const ScreenAbout(),
          '/sign_in': (context) => ScreenSignIn(),
          '/sign_up': (context) => ScreenSignUp(),
        },
        theme: enderNoteTheme,
        home: ScreenHero(rootPath: rootPath),
      ),
    );
  }
}
