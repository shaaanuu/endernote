import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeNew extends StatelessWidget {
  const HomeNew({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> fetchDir() async {
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

      final List<String> allEntities = [];

      void collectEntities(Directory dir) {
        final entities = dir.listSync();
        for (var entity in entities) {
          allEntities.add(entity.path);
          if (entity is Directory) {
            collectEntities(entity);
          }
        }
      }

      collectEntities(folder);

      return allEntities;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("For testing purposes..."),
      ),
      body: FutureBuilder(
        future: fetchDir(),
        builder: (context, snapshot) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Text(
              snapshot.data![index],
            ),
          ),
        ),
      ),
    );
  }
}
