import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeNew extends StatelessWidget {
  const HomeNew({super.key});

  @override
  Widget build(BuildContext context) {
    Future fetchDir() async {
      late final String path;

      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        final directory = await getApplicationDocumentsDirectory();
        path = '${directory.path}/Endernote';
      } else {
        final directory = await getExternalStorageDirectory();
        path = '${directory!.path}/Endernote';
      }
      final folder = Directory(path);
      print(folder);

      return folder.path;
      // if (await folder.exists()) {
      //   return folder.path;
      // } else {
      //   await folder.create(recursive: true);
      //   return folder.path;
      // }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("For testing purposes..."),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("The documents directory is....."),
          FutureBuilder(
            future: fetchDir(),
            builder: (context, snapshot) => Text(
              snapshot.hasData ? snapshot.data : "none..",
            ),
          ),
        ],
      ),
    );
  }
}
