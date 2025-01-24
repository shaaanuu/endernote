import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ficonsax/ficonsax.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_fab.dart';
import '../../widgets/drawer.dart';

class ScreenHero extends StatelessWidget {
  const ScreenHero({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: showDrawer(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconsaxOutline.menu_1),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text('Endernote'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Craft your second brain',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SvgPicture.asset(
                "lib/assets/brain.svg",
                height: 150,
                color: Theme.of(context).extension<EndernoteColors>()?.clrText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Create new note'),
                  ),
                  Icon(IconsaxOutline.note_2, size: 22),
                ],
              ),
              onPressed: () async {
                final newFile = File(
                  '$rootPath/new_note_${DateTime.now().millisecondsSinceEpoch}.md',
                );
                await newFile.create();

                Navigator.pushNamed(
                  context,
                  '/canvas',
                  arguments: newFile.path,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Open a note'),
                  ),
                  Icon(IconsaxOutline.folder, size: 21),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFAB(rootPath: rootPath),
    );
  }
}
