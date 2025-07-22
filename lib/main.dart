import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/directory/directory_bloc.dart';
import 'bloc/directory/directory_events.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_states.dart';
import 'presentation/screens/about/screen_about.dart';
import 'presentation/screens/canvas/screen_canvas.dart';
import 'presentation/screens/home/screen_home.dart';
import 'presentation/screens/search/screen_search.dart';
import 'presentation/screens/settings/screen_settings.dart';
import 'presentation/theme/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    MyApp(rootPath: await fetchRootPath()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.rootPath,
  });

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DirectoryBloc()..add(FetchDirectory(rootPath)),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Endernote',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/canvas': (context) => ScreenCanvas(),
              '/settings': (context) => const ScreenSettings(),
              '/about': (context) => const ScreenAbout(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/search') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => ScreenSearch(
                    searchQuery: args['query'],
                    rootPath: args['rootPath'],
                  ),
                );
              }
              return null;
            },
            theme: appThemeData[themeState.theme],
            home: ScreenHome(rootPath: rootPath),
          );
        },
      ),
    );
  }
}
