import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_states.dart';
import 'presentation/screens/about/screen_about.dart';
import 'presentation/screens/canvas/screen_canvas.dart';
import 'presentation/screens/chest_room/screen_chest_room.dart';
import 'presentation/screens/chest_view/screen_chest_view.dart';
import 'presentation/screens/welcome/screen_welcome.dart';
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
              '/chest-room': (context) => ScreenChestRoom(),
              '/chest-view': (context) => ScreenChestView(rootPath: rootPath),
            },
            theme: appThemeData[themeState.theme],
            home: ScreenWelcome(),
          );
        },
      ),
    );
  }
}
