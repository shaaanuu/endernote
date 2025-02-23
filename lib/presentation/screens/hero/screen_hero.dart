import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ficonsax/ficonsax.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Untangle',
                      style: TextStyle(
                        fontFamily: 'Barriecito',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf2cdcd),
                        height: 1.1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0, top: 10),
                          child: SvgPicture.asset(
                            'lib/assets/brain.svg',
                            width: 70,
                            height: 70,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFf38ba8),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const Text(
                          'Your',
                          style: TextStyle(
                            fontFamily: 'Barriecito',
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFb4befe),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Thoughts',
                      style: TextStyle(
                        fontFamily: 'Barriecito',
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFcba6f7),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      IconsaxOutline.note_2,
                      size: 24,
                      color: Color(0xFF1e1e2e),
                    ),
                    label: const Text(
                      'Create new note',
                      style: TextStyle(
                        color: Color(0xFF1e1e2e),
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF89b4fa),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
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
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    icon: const Icon(IconsaxOutline.folder),
                    label: const Text('Open a note'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(rootPath: rootPath),
    );
  }
}
