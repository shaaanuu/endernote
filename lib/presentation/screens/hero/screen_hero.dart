import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ficonsax/ficonsax.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_fab.dart';

class ScreenHero extends StatelessWidget {
  const ScreenHero({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<bool> hasText = ValueNotifier<bool>(false);

    searchController.addListener(() {
      hasText.value = searchController.text.isNotEmpty;
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search your notes",
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                        fontSize: 14,
                        fontFamily: 'FiraCode',
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: hasText,
                builder: (context, hasTextValue, child) {
                  return IconButton(
                    onPressed: () {
                      if (hasTextValue) {
                        searchController.clear();
                      } else {
                        Navigator.pushNamed(context, '/settings');
                      }
                    },
                    icon: Icon(
                      hasTextValue
                          ? IconsaxOutline.search_normal_1
                          : IconsaxOutline.setting_2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
