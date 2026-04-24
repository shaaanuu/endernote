import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_states.dart';
import 'data/models/chest_record.dart';
import 'presentation/screens/about/screen_about.dart';
import 'presentation/screens/canvas/screen_canvas.dart';
import 'presentation/screens/chest_room/screen_chest_room.dart';
import 'presentation/screens/chest_view/screen_chest_view.dart';
import 'presentation/screens/welcome/screen_welcome.dart';
import 'presentation/screens/settings/screen_settings.dart';
import 'presentation/theme/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isWindows) {
    await Permission.storage.request();
  }

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ChestRecordSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
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
              '/chest-room': (context) => ScreenChestRoom(isar: isar),
              '/chest-view': (context) => ScreenChestView(),
            },
            theme: appThemeData[themeState.theme],
            home: ScreenWelcome(isar: isar),
          );
        },
      ),
    );
  }
}
